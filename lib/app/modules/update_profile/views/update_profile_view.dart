import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user['nip'];
    controller.namaC.text = user['nama'];
    controller.emailC.text = user['email'];
    return Scaffold(
        appBar: AppBar(
          title: Text('UpdateProfileView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.namaC,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.emailC,
              readOnly: true,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.nipC,
              autocorrect: false,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Photo Profile"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<UpdateProfileController>(
                  builder: (c) {
                    if (c.image != null) {
                      return ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  File(c.image!.path),
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    } else if (user["profile"] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(user["profile"]),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                controller.deleteImage(user["uid"]);
                              },
                              child: Text("Delete Photo"))
                        ],
                      );
                    } else {
                      return Text("No Image");
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      controller.selectImage();
                    },
                    child: Text("Choose Image"))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    controller.updateProfile(user["uid"]);
                  }
                },
                child: Obx(() =>
                    Text(controller.isLoading.isFalse ? "Update" : "Loading"))),
          ],
        ));
  }
}
