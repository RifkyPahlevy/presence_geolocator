import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:precense_geolocator/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController passC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassword() async {
    if (passC.text.isNotEmpty) {
      try {
        String email = auth.currentUser!.email!;
        await auth.currentUser!.updatePassword(passC.text);
        await auth.signOut();
        await auth.signInWithEmailAndPassword(
            email: email, password: passC.text);
        Get.offAllNamed(Routes.HOME);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
        }
      } catch (e) {}
    } else {}
  }
}
