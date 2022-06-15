import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamGetProfile() async* {
    try {
      String uid = auth.currentUser!.uid;
      yield* firestore.collection("pegawai").doc(uid).snapshots();
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "${e}");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamGetPresence() async* {
    try {
      String uid = auth.currentUser!.uid;
      yield* firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .orderBy("date", descending: true)
          .limit(5)
          .snapshots();
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "${e}");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> todayPresence() async* {
    try {
      String uid = auth.currentUser!.uid;
      String todayDocID =
          DateFormat().add_yMd().format(DateTime.now()).replaceAll("/", "-");

      yield* firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .doc(todayDocID)
          .snapshots();
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "${e}");
    }
  }
}
