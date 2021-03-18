import 'package:get/get.dart';

import 'global_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    final global = Get.put(GlobalController(), permanent: true);
    global.init();
  }
}