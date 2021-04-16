import 'package:blue_demo/data/controller/global_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ControllerController extends GetxController {
  Rx<Color> _currentColor = Get.find<GlobalController>().selectColor.value.obs;
  var _auroraState = '停机'.obs;
  var _motorState = '送料'.obs;


  Color get currentColor => _currentColor.value;
  String get auroraState => _auroraState.value;
  String get motorState => _motorState.value;

  set auroraState(value) => _auroraState(value);
  set motorState(value) => _motorState(value);
  set currentColor(value) => _currentColor(value);
}
