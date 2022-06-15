import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  XFile? image;

  void selectImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print(image!.name);
      print(image!.name.split(".").last);
    } else {
      print(image);
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, String> data = {
          "nama": namaC.text,
        };

        if (image != null) {
          String ext = image!.name.split(".").last;
          File file = File(image!.path);
          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlPict =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({"profile": urlPict});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        isLoading.value = false;
        Get.back();
        Get.snackbar("Berhasil", "Data Berhasil Diperbarui");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", e.toString());
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Silahkan isi data dengan lengkap");
    }
  }

  void deleteImage(String id) async {
    try {
      await firestore
          .collection("pegawai")
          .doc(id)
          .update({"profile": FieldValue.delete()});
      Get.back();
      Get.snackbar("Berhasil", "Foto Berhasil Dihapus");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Silahkan isi data dengan lengkap");
    }
  }
}
