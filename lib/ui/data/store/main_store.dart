import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';
import 'get_cmykw.dart';

part 'main_store.g.dart';

final mainStore = MainStore();

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  Color selectColor;

  @observable
  bool isScanning = false;

  @observable
  BluetoothDevice connectedDevice;

  @observable
  BluetoothCharacteristic characteristic;

  @observable
  var cmykw = CMYKW();

  @action
  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor = Color(color | 0xFF000000);
    cmykw = RGB_CMYG(Rgb2CMYG(
        rgb: [selectColor.red, selectColor.green, selectColor.blue], TS: 200));
    Stream.periodic(Duration(seconds: 2)).listen((event) async {
      final pref = await SharedPreferences.getInstance();
      pref.setInt('color', selectColor.value);
    });
  }

  @action
  Future<void> setColor(Color color) async {
    selectColor = color;
    cmykw =
        RGB_CMYG(Rgb2CMYG(rgb: [color.red, color.green, color.blue], TS: 200));
  }

  @action
  Future<void> sendData(List<int> data) async {
    if (connectedDevice != null && characteristic != null) {
      await characteristic.write(data, withoutResponse: false);
      return;
    }
    throw Exception('设备未初始化');
  }

  Future<void> setBleListen() async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen((event) {
      print('Received Data: $event');
    });
  }

  @action
  Future<void> connectDevice(BluetoothDevice device,
      [bool isConnect = false]) async {
    try {
      if (!isConnect) {
        await device.connect(timeout: Duration(seconds: 10));
      }
      connectedDevice = device;
      final service = await device.discoverServices();
      service.forEach((element) {
        if (element.uuid.toString() == BLE_SERVICE_UUID) {
          element.characteristics.forEach((element) {
            if (element.uuid.toString() == BLE_READ_WRITE_UUID) {
              characteristic = element;
            }
          });
        }
      });
      setBleListen();
      if (characteristic == null) {
        throw Exception('没有找到蓝牙对应的服务!');
      }
    } on TimeoutException {
      throw Exception('蓝牙连接超时');
    }
  }
}
