import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:blue_demo/ui/data/constant.dart';
import 'package:blue_demo/utils/get_cmykw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class GlobalController extends GetxController {
  var selectColor = Rx<Color>(Colors.blue);

  var nowColor = Rx<Color>();

  var isScanning = false.obs;

  var stateHint = '点击蓝牙图标开始连接'.obs;

  var connectedDevice = Rx<BluetoothDevice>();

  var characteristic = Rx<BluetoothCharacteristic>();

  var cmykw = CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0).obs;

  var nowCmykw = CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0).obs;

  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor(Color(color | 0xFF000000));
    nowColor(Color(color | 0xFF000000));
    cmykw(RGB_CMYG(Rgb2CMYG(rgb: [
      selectColor.value.red,
      selectColor.value.green,
      selectColor.value.blue
    ], TS: M_TS)));

    Stream.periodic(Duration(seconds: 2)).listen((event) async {
      final pref = await SharedPreferences.getInstance();
      pref.setInt('color', selectColor.value.value);
    });
  }

  Future<void> setColor(Color color) async {
    selectColor(Color(color.value | 0xFF000000));
    print(color.value);
    cmykw(RGB_CMYG(
        Rgb2CMYG(rgb: [color.red, color.green, color.blue], TS: M_TS)));
  }

  Future<void> sendColor() async {
    if (connectedDevice.value != null && characteristic.value != null) {
      final data = [
        cmykw.value.c,
        cmykw.value.y,
        cmykw.value.m,
        cmykw.value.k,
        cmykw.value.w,
        0x40,
        0x40,
        0x01,
        0x01,
        0x0d,
        0x0a
      ];
      await sendData(data);
      nowColor(selectColor.value);
    }
  }

  Future<void> sendPause() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0xFF, 0x0, 0x0d, 0x0a];
    await sendData(data);
  }

  Future<void> sendStart() async {
    final data = [
      cmykw.value.c,
      cmykw.value.y,
      cmykw.value.m,
      cmykw.value.k,
      cmykw.value.w,
      0x40,
      0x40,
      0xFF,
      0x1,
      0x0d,
      0x0a
    ];
    await sendData(data);
  }

  Future<void> sendPush() async {
    final data = [
      cmykw.value.c,
      cmykw.value.y,
      cmykw.value.m,
      cmykw.value.k,
      cmykw.value.w,
      0x40,
      0x40,
      0x1,
      0xFF,
      0x0d,
      0x0a
    ];
    await sendData(data);
  }

  Future<void> sendPop() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0x0, 0xFF, 0x0d, 0x0a];
    await sendData(data);
  }

  Future<void> sendData(List<int> data) async {
    if (connectedDevice.value != null && characteristic.value != null) {
      await characteristic.value.write(data, withoutResponse: false);
      print(
          '发送数据: ${data.map((e) => e.toRadixString(16)).map((e) => e.length == 1 ? '0$e' : e).join(' ')}');
      print('发送数据: ${data.map((e) => e.toString()).join(' ')}');
      nowCmykw = cmykw;
      return;
    }
  }

  Future<void> setBleListen() async {
    await characteristic.value.setNotifyValue(true);
    characteristic.value.value.listen((event) {
      print('收到数据: $event');
    });
  }

  void setHint(String value) {
    stateHint.value = value;
  }

  Future<void> findAndConnect() async {
    StreamSubscription<bool> scanListener;
    StreamSubscription<List<ScanResult>> resultListener;
    try {
      stateHint.value = '连接中, 请稍后...';
      final adapter = FlutterBlue.instance;
      final connectedData = await adapter.connectedDevices;
      final data =
          connectedData.where((element) => element.id.id == HC08_MAC).toList();
      if (data.isNotEmpty) {
        await connectDevice(data[0], true);
      } else {
        await adapter.startScan(timeout: Duration(seconds: 10));
        var deviceCompleter = Completer<BluetoothDevice>();
        resultListener = adapter.scanResults.listen((event) {
          event.forEach((element) {
            if (element.device.id.id == HC08_MAC) {
              print(element.device.id.id);
              if (!deviceCompleter.isCompleted) {
                deviceCompleter.complete(element.device);
              }
            }
          });
        });
        scanListener = adapter.isScanning.listen((event) {
          if (event) {
            stateHint.value = '连接中, 请稍后...';
          } else {
            if (!deviceCompleter.isCompleted) {
              deviceCompleter.completeError(Exception('没有发现设备'));
            }
          }
        });
        var device = await deviceCompleter.future;
        await connectDevice(device);
      }
    } on Exception catch(e) {
      print(e);
      stateHint.value = '连接失败, 点击重试';
      rethrow;
    } finally {
      scanListener?.cancel();
      resultListener?.cancel();
    }
  }

  Future<void> connectDevice(BluetoothDevice device,
      [bool isConnect = false]) async {
    try {
      if (!isConnect) {
        await device.connect(timeout: Duration(seconds: 10));
      }
      connectedDevice(device);
      final service = await device.discoverServices();
      service.forEach((element) {
        if (element.uuid.toString() == BLE_SERVICE_UUID) {
          element.characteristics.forEach((element) {
            if (element.uuid.toString() == BLE_READ_WRITE_UUID) {
              characteristic(element);
            }
          });
        }
      });
      await FlutterBlue.instance.stopScan();
      stateHint.value = '连接成功!';
      if (characteristic.value == null) {
        stateHint.value = '没有找到蓝牙对应的服务!';
        throw Exception('没有找到蓝牙对应的服务!');
      }
      setBleListen();
    } on TimeoutException {
      stateHint.value = '蓝牙连接超时!';
      throw Exception('蓝牙连接超时');
    }
  }
}
