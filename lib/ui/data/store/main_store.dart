import 'dart:async';
import 'dart:ui';
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
  Color nowColor;

  @observable
  bool isScanning = false;

  @observable
  BluetoothDevice connectedDevice;

  @observable
  BluetoothCharacteristic characteristic;

  @observable
  var cmykw = CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @observable
  var nowCmykw = CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @action
  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor = Color(color | 0xFF000000);
    nowColor = selectColor;
    cmykw = RGB_CMYG(Rgb2CMYG(
        rgb: [selectColor.red, selectColor.green, selectColor.blue], TS: M_TS));

    Stream.periodic(Duration(seconds: 2)).listen((event) async {
      final pref = await SharedPreferences.getInstance();
      pref.setInt('color', selectColor.value);
    });
  }

  @action
  Future<void> setColor(Color color) async {
    selectColor = color;
    cmykw =
        RGB_CMYG(Rgb2CMYG(rgb: [color.red, color.green, color.blue], TS: M_TS));
  }

  @action
  Future<void> sendColor() async {
    if (connectedDevice != null && characteristic != null) {
      final data = [
        cmykw.c,
        cmykw.y,
        cmykw.m,
        cmykw.k,
        cmykw.w,
        0x40,
        0x40,
        0x01,
        0x01,
        0x0d,
        0x0a
      ];
      await sendData(data);
      nowColor = selectColor;
    }
  }

  @action
  Future<void> sendPause() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0xFF, 0x0, 0x0d, 0x0a];
    await sendData(data);
  }

  @action
  Future<void> sendStart() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0xFF, 0x1, 0x0d, 0x0a];
    await sendData(data);
  }

  @action
  Future<void> sendPush() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0x1, 0xFF, 0x0d, 0x0a];
    await sendData(data);
  }

  @action
  Future<void> sendPop() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0x0, 0xFF, 0x0d, 0x0a];
    await sendData(data);
  }

  @action
  Future<void> sendData(List<int> data) async {
    if (connectedDevice != null && characteristic != null) {
      await characteristic.write(data, withoutResponse: false);
      print(
          '发送数据: ${data.map((e) => e.toRadixString(16)).map((e) => e.length == 1 ? '0$e' : e).join(' ')}');
      print('发送数据: ${data.map((e) => e.toString()).join(' ')}');
      nowCmykw = cmykw;
      return;
    }
  }

  Future<void> setBleListen() async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen((event) {
      print('收到数据: $event');
    });
  }

  @action
  Future<void> findAndConnect() async {
    final adapter = FlutterBlue.instance;
    final connectedData = await adapter.connectedDevices;
    final data = connectedData.where((element) => element.id.id == HC08_MAC).toList();
    if (data.isNotEmpty) {
      await connectDevice(data[0], true);
    } else {
      adapter.startScan(timeout: Duration(seconds: 10));
      var deviceCompleter = Completer<BluetoothDevice>();
      adapter.scanResults.listen((event) {
        event.forEach((element) {
          if (element.device.id.id == HC08_MAC) {
            print(element.device.id.id);
            if (!deviceCompleter.isCompleted) {
              deviceCompleter.complete(element.device);
            }
          }
        });
      }, onDone: () {
        if (!deviceCompleter.isCompleted) {
          deviceCompleter.completeError(Exception('没有找到设备'));
        }

      }, onError: (_) {
        if (!deviceCompleter.isCompleted) {
          deviceCompleter.completeError(Exception('寻找设备出错!'));
        }
      });
      var device = await deviceCompleter.future;
      await connectDevice(device);
    }
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
      await FlutterBlue.instance.stopScan();
      if (characteristic == null) {
        throw Exception('没有找到蓝牙对应的服务!');
      }
      setBleListen();
    } on TimeoutException {
      throw Exception('蓝牙连接超时');
    }
  }
}
