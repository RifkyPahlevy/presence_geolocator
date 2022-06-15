import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:precense_geolocator/app/controllers/page_view_controller.dart';

import 'package:precense_geolocator/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamGetProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.data() == null) {
                return Center(
                  child: Text('There is no profile'),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Center(child: Text("X")),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                user["position"] != null
                                    ? "${user['address']} "
                                    : "Belum ada lokasi",
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user["job"]}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${user["nip"]}",
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${user["nama"]}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: controller.todayPresence(),
                              builder: (context, snapToday) {
                                if (snapToday.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                Map<String, dynamic>? dataToday =
                                    snapToday.data?.data();
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Masuk",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(dataToday?["masuk"]["date"] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday!["masuk"]["date"]))}"),
                                      ],
                                    ),
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: Colors.black87,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Keluar",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(dataToday?["keluar"]?["date"] ==
                                                null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday!["keluar"]["date"]))}")
                                      ],
                                    ),
                                  ],
                                );
                              }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[300],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last Days 5",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.ALL_PRECENSE);
                            },
                            child: Text("See more")),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamGetPresence(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data?.docs.length == 0 ||
                              snapshot.data == null) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Text("Belum ada presensi"),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${DateFormat.yMMMEd().format(DateTime.parse(daftarAbsen["date"]))}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(daftarAbsen["keluar"]?['date'] !=
                                                  null
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
                        })
                  ],
                );
              } else {
                return Center(child: Text("Data Tidak Ditemukan"));
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixed,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.index.value, //optional, default as 0
          onTap: (int i) => pageC.selectPage(i),
        ));
  }
}
