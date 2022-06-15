import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../routes/app_pages.dart';

class PageViewController extends GetxController {
  RxInt index = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void selectPage(int i) async {
    switch (i) {
      case 0:
        index.value = i;
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        print("Absenn");

        Map<String, dynamic> dataResponse = await determinePosition();

        if (dataResponse["error"] != true) {
          Position posisi = dataResponse["position"];

          List<Placemark> placemarks =
              await placemarkFromCoordinates(posisi.latitude, posisi.longitude);
          String address =
              "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}";

          await updateLokasi(posisi, address);

          //mengatur atau mendapatkan jarak
          double distance = Geolocator.distanceBetween(
              -6.2555521, 106.8353884, posisi.latitude, posisi.longitude);

          presence(posisi, address, distance);
        } else {
          Get.snackbar("Terjadi Kesalahan",
              "Gagal mendapatkan lokasi, Silahkan aktifkan gps anda");
        }

        break;
      case 2:
        index.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
    }
  }

  Future<void> presence(
      Position posisi, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPres =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPres = await colPres.get();
    String todayDocID =
        DateFormat().add_yMd().format(DateTime.now()).replaceAll("/", "-");

    String status = "Di luar area";
    // jika jaraknya lebih dari 100 meter di luar area
    if (distance <= 100) {
      status = "Di dalam area";
    }
    if (snapPres.docs.length == 0) {
      //belum pernah absen sama sekali
      await Get.defaultDialog(
          title: "Validation Presence",
          middleText: "Apakah anda ingin absen (masuk) untuk hari ini ?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
            ElevatedButton(
                onPressed: () {
                  colPres.doc(todayDocID).set({
                    "date": DateTime.now().toIso8601String(),
                    "masuk": {
                      "address": address,
                      "date": DateTime.now().toIso8601String(),
                      "lat": posisi.latitude,
                      "long": posisi.longitude,
                      "status": status,
                      "distance": distance
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "Anda telah mengisi absen hari ini");
                },
                child: Text("IYA"))
          ]);
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPres.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        Map<String, dynamic> dataAbsenToday = todayDoc.data()!;
        if (dataAbsenToday["keluar"] != null) {
          Get.snackbar("Terima Kasih",
              "Anda telah melakukan absen masuk dan keluar untuk hari ini");
        } else {
          //absen keluar

          await Get.defaultDialog(
              title: "Validation Presence",
              middleText: "Apakah anda ingin absen (keluar) untuk hari ini ?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      colPres.doc(todayDocID).update({
                        "date": DateTime.now().toIso8601String(),
                        "keluar": {
                          "address": address,
                          "date": DateTime.now().toIso8601String(),
                          "lat": posisi.latitude,
                          "long": posisi.longitude,
                          "status": status,
                          "distance": distance
                        }
                      });
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Anda telah mengisi absen (Keluar) hari ini");
                    },
                    child: Text("IYA"))
              ]);
        }
      } else {
        await Get.defaultDialog(
            title: "Validation Presence",
            middleText: "Apakah anda ingin absen (masuk) untuk hari ini ?",
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    colPres.doc(todayDocID).set({
                      "date": DateTime.now().toIso8601String(),
                      "masuk": {
                        "address": address,
                        "date": DateTime.now().toIso8601String(),
                        "lat": posisi.latitude,
                        "long": posisi.longitude,
                        "status": status,
                        "distance": distance
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil",
                        "Anda telah mengisi absen (masuk) hari ini");
                  },
                  child: Text("IYA"))
            ]);
      }
    }
  }

  Future<void> updateLokasi(Position posisi, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {"latitude": posisi.latitude, "longitude": posisi.longitude},
      "address": address
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {"message": "Location services are not enabled", "error": true};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Location permissions are denied forever",
          "error": true
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Location permissions are denied forever",
        "error": true
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position posisi = await Geolocator.getCurrentPosition();
    return {
      "message": "Posisi anda berhasil ditemukan",
      "position": posisi,
      "error": false
    };
  }
}
