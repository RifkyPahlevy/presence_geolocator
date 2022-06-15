import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_precense_controller.dart';

class AllPrecenseView extends GetView<AllPrecenseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPrecenseController>(
        builder: (c) {
          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getPresence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data?.docs.length == 0 &&
                    snapshot.data?.docs == null) {
                  return Center(
                    child: Text("Tidak ada data"),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> daftarAbsen =
                        snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRECENSE,
                                arguments: daftarAbsen);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${DateFormat.yMMMEd().format(DateTime.parse(daftarAbsen["date"]))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(daftarAbsen["masuk"] != null
                                    ? "${DateFormat.jms().format(DateTime.parse(daftarAbsen["masuk"]["date"]))}"
                                    : "-"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Keluar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(daftarAbsen["keluar"]?['date'] != null
                                    ? "${DateFormat.jms().format(DateTime.parse(daftarAbsen["keluar"]["date"]))}"
                                    : "-"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
            child: Container(
              padding: EdgeInsets.all(10),
              height: 400,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onSubmit: (obj) {
                  if (obj != null) {
                    if ((obj as PickerDateRange).endDate != null) {
                      controller.pictDate(obj.startDate!, obj.endDate!);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.format_list_numbered_sharp),
      ),
    );
  }
}
