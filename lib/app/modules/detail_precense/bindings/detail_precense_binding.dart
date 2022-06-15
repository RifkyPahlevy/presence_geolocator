import 'package:get/get.dart';

import '../controllers/detail_precense_controller.dart';

class DetailPrecenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPrecenseController>(
      () => DetailPrecenseController(),
    );
  }
}
