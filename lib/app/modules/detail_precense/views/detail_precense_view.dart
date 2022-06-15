import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_precense_controller.dart';

class DetailPrecenseView extends GetView<DetailPrecenseController> {
  var daftarAbsen = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat('dd-MM-yyyy').format(DateTime.parse(daftarAbsen['date']))}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Jam : ${DateFormat.jms().format(DateTime.parse(daftarAbsen['masuk']['date']))}",
                ),
                Text(
                  daftarAbsen['masuk']?['lat'] == null &&
                          daftarAbsen['masuk']?['long'] == null
                      ? "posisi : ${daftarAbsen['masuk']!['lat']}, ${daftarAbsen['masuk']!['long']}"
                      : "Posisi : -8883.345 - 7766673",
                ),
                Text(
                  daftarAbsen['masuk']?['address'] == null
                      ? "Address : -"
                      : "Address : ${daftarAbsen['masuk']!['address']}",
                ),
                Text(daftarAbsen['masuk']?['status'] == null
                    ? "Status : -"
                    : "Status : ${daftarAbsen['masuk']!['status']}"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  daftarAbsen['keluar']?['date'] == null
                      ? "jam : -"
                      : "Jam : ${DateFormat.jms().format(DateTime.parse(daftarAbsen['masuk']['date']))}",
                ),
                Text(daftarAbsen['keluar']?['lat'] == null &&
                        daftarAbsen['keluar']?['long'] == null
                    ? "Posisi : -"
                    : "posisi : ${daftarAbsen['keluar']!['lat']}, ${daftarAbsen['keluar']!['long']}"),
                Text(
                  daftarAbsen['keluar']?['address'] == null
                      ? "Address : -"
                      : "Address : ${daftarAbsen['keluar']!['address']}",
                ),
                Text(
                  daftarAbsen['keluar']?['status'] == null
                      ? "Status : -"
                      : "Status : ${daftarAbsen['keluar']!['status']}",
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
          )
        ],
      ),
    );
  }
}
