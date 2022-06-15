import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
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
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.passC,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () => controller.isHidden.toggle(),
                      icon: Icon(Icons.remove_red_eye_sharp)),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Obx(() => CheckboxListTile(
                value: controller.isCheck.value,
                onChanged: (value) {
                  controller.isCheck.toggle();
                },
                title: Text("Remember Me"),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: Text("Forget Password")),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child: Obx(() =>
                  Text(controller.isLoading.isFalse ? "Login" : "Loading..")))
        ],
      ),
    );
  }
}
