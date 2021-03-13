import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main_store.g.dart';

final mainStore = MainStore();

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  Color selectColor;

  @observable
  bool isConnect = false;

  @observable
  bool isScanning = false;

  @observable
  BluetoothDevice connectedDevice;

  @action
  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor = Color(color);
  }

  @action
  Future<void> setColor(Color color) async {
    selectColor = color;
    final pref = await SharedPreferences.getInstance();
    pref.setInt('color', color.value);
  }

// @action
// Future<bool> connectDevice() async {
//   final deviceList = <ScanResult>{};
//   isScanning = true;
//   final flutterBlue = FlutterBlue.instance;
//   flutterBlue.startScan(
//       timeout: Duration(seconds: 10), allowDuplicates: false);
//   flutterBlue.scanResults.listen((results) {
//     results.forEach(deviceList.add);
//   });
//   await Future.delayed(Duration(seconds: 10));
//   flutterBlue.stopScan();
//   deviceList.forEach((e) {
//     print('${e.device.id.id} ${e.device.name} ${e.rssi} ');
//   });
//   isScanning = false;
//   return false;
// }
}
