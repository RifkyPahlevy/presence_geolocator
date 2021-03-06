import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:precense_geolocator/app/controllers/page_view_controller.dart';
import 'package:precense_geolocator/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ProfileView'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user["nama"]}";
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            user["profile"] != null
                                ? user["profile"] != ""
                                    ? user["profile"]
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("${user['nama'].toString().toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${user['email']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                    leading: Icon(Icons.update),
                    title: Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: Icon(Icons.key_rounded),
                    title: Text("Update Password"),
                  ),
                  if (user["role"] == "admin")
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      leading: Icon(Icons.person_add),
                      title: Text("Add Pegawai"),
                    ),
                  ListTile(
                    onTap: () {
                      controller.logout();
                    },
                    leading: Icon(Icons.logout_rounded),
                    title: Text("Logout"),
                  )
                ],
              );
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
