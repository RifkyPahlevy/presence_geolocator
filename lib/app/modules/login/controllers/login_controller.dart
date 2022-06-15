import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isCheck = false.obs;
  RxBool isHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        isLoading.value = false;
        if (userCredential.user!.emailVerified == true) {
          if (passC.text == "password") {
            isLoading.value = false;
            Get.offAllNamed(Routes.NEW_PASSWORD);
          } else {
            isLoading.value = false;
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.defaultDialog(
              title: "Verifikasi Email",
              middleText:
                  "Email anda belum diverifikasi, Apakah anda ingin mengirim ulang email verifikasi?",
              actions: [
                OutlinedButton(
                    onPressed: () async {
                      try {
                        await auth.currentUser!.sendEmailVerification();
                        Get.snackbar("Email Verifikasi",
                            "Email verifikasi telah dikirim");
                      } catch (e) {
                        Get.snackbar("Terjadi Kesalahan",
                            "Email tidak dapat dikirim silahkan hubungi admin");
                      }
                    },
                    child: Text("Oke")),
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Tidak"))
              ]);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "User tidak terdaftar");
          isLoading.value = false;
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
          isLoading.value = false;
        }
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Data tidak boleh kosong");
    }
  }
}
