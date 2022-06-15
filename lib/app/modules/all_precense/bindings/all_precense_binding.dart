import 'package:get/get.dart';

import '../controllers/all_precense_controller.dart';

class AllPrecenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPrecenseController>(
      () => AllPrecenseController(),
    );
  }
}
