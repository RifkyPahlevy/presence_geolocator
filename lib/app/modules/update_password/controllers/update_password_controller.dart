import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confrimC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void updatePassword() async {
    if (currC.text.isNotEmpty &&
        newPassC.text.isNotEmpty &&
        confrimC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String emailCurr = auth.currentUser!.email!;

        await auth.signInWithEmailAndPassword(
            email: emailCurr, password: currC.text);
        await auth.currentUser!.updatePassword(newPassC.text);
        await auth.signOut();
        await auth.signInWithEmailAndPassword(
            email: emailCurr, password: newPassC.text);
        Get.back();
        Get.snackbar("Berhasil", "Password Berhasil Diperbarui");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang anda masukkan salah");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Silahkan isi data dengan lengkap");
    }
  }
}
