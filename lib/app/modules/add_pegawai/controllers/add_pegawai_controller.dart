import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  TextEditingController namaC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();
  TextEditingController jobC = TextEditingController();

  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> processAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        String emailAdmin = auth.currentUser!.email!;
        print(emailAdmin);
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");
        await pegawaiCredential.user!.sendEmailVerification();

        String uid = pegawaiCredential.user!.uid;
        await firestore.collection("pegawai").doc(uid).set({
          "nama": namaC.text,
          "nip": nipC.text,
          "email": emailC.text,
          "job": jobC.text,
          "uid": uid,
          "created_at": DateTime.now().toIso8601String(),
        });

        await auth.signOut();
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);
        isLoading.value = false;
        Get.back(); //tutup dialog

        Get.back(); //back to home
        Get.snackbar("Berhasil Tambah", "Berhasil Menambah Pegawai",
            snackPosition: SnackPosition.BOTTOM);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "Email sudah digunakan");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password yang anda masukan salah");
        }
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Silahkan isi password untuk validasi");
    }
  }

  void addPegawai() async {
    if (namaC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        jobC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Konfirmasi Password Anda",
          content: Column(
            children: [
              TextField(
                controller: passAdminC,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password Admin", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
            OutlinedButton(
                onPressed: () {
                  if (isLoading.isFalse) {
                    processAddPegawai();
                  }
                },
                child: Obx(
                    () => Text(isLoading.isFalse ? "Tambah" : "Loading...")))
          ]);
    } else {
      Get.snackbar("Terjadi Kesalahan", "Data tidak boleh kosong");
      isLoading.value = false;
      Get.back();
    }
  }
}
