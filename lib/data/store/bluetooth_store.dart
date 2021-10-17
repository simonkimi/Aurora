import 'dart:async';
import 'dart:ui';

import 'package:aurora/data/model/ble_ext.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/page/task/store/task_maker_store.dart';
import 'package:aurora/utils/get_cmykw.dart';
import 'package:aurora/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobx/mobx.dart';

import 'main_store.dart';

part 'bluetooth_store.g.dart';

class DeviceNotConnectException with Exception {}

class BluetoothStore = BluetoothStoreBase with _$BluetoothStore;

enum ConnectState {
  Waiting,
  Scanning,
  Connecting,
  DeviceNotFound,
  TimeOut,
  Fail,
  Connected,
}

class SendHistory {
  SendHistory(this.data);

  final DateTime time = DateTime.now();
  final List<int> data;
}

abstract class BluetoothStoreBase with Store {
  @observable
  bool isScanning = false;

  @observable
  BluetoothDevice? connectedDevice;

  @observable
  BluetoothCharacteristic? characteristic;

  @observable
  ConnectState state = ConnectState.Waiting;

  @observable
  bool isSend = true;
  final sendHistory = ObservableList<SendHistory>();
  final receiveHistory = ObservableList<SendHistory>();

  Future<void> sendData(List<int> data) async {
    print('-' * 50);
    print('数据: ${data.length}');
    print('发送数据: ${to16String(data)}');
    print('发送数据: ${to10String(data)}');
    print('-' * 50);
    if (connectedDevice != null && characteristic != null) {
      await characteristic!.write(data, withoutResponse: false);
      sendHistory.add(SendHistory(data));
      return;
    }
    BotToast.showText(text: '设备未连接');
    throw Exception('设备未连接');
  }

  Future<void> setBleListen() async {
    await characteristic!.setNotifyValue(true);
    characteristic!.value.listen((event) {
      print('收到数据: $event');
      receiveHistory.add(SendHistory(event));
    });
  }

  Future<void> sendIn() async {
    if (mainStore.version == MessageVersion.V3) {
      await _sendV3In();
    } else {
      await _sendV1Start();
    }
  }

  Future<void> sendStop() async {
    if (mainStore.version == MessageVersion.V3) {
      await _sendV3Stop();
    } else {
      await _sendV1Pause();
    }
  }

  Future<void> sendOut() async {
    if (mainStore.version == MessageVersion.V3) {
      await _sendV3Out();
    } else {
      await _sendV1Pop();
    }
  }

  Future<void> sendCmykw(CMYKW cmykw) async {
    if (mainStore.version == MessageVersion.V3) {
      await _sendV3Cmykw(cmykw);
    } else {
      await _sendV1Cmykw(cmykw);
    }
  }

  Future<void> _sendV3In() async {
    await sendData(buildBluetooth(
      direction: MotorDirection.Forward,
      cmykw: mainStore.cmykw,
      color: mainStore.selectColor,
    ));
    mainStore.sendColor();
  }

  Future<void> _sendV3Stop() async {
    await sendData(buildBluetooth(
        direction: MotorDirection.Stop,
        cmykw: CMYKW.zero(),
        color: Colors.black));
  }

  Future<void> _sendV3Cmykw(CMYKW cmykw) async {
    await sendData(buildBluetooth(
        direction: MotorDirection.Forward, cmykw: cmykw, color: Colors.white));
  }

  Future<void> _sendV1Cmykw(CMYKW cmykw) async {
    final data = <int>[
      cmykw.c,
      cmykw.y,
      cmykw.m,
      cmykw.k,
      cmykw.w,
      0x40,
      0x40,
      0xFF,
      0x1,
      0x0d,
      0x0a
    ];
    await sendData(data);
  }

  Future<void> _sendV3Out() async {
    await sendData(buildBluetooth(
      direction: MotorDirection.Reverse,
      cmykw: const CMYKW(
        c: 50,
        m: 50,
        y: 50,
        k: 50,
        w: 50,
      ),
      color: Colors.black,
    ));
  }

  Future<void> sendTask(TaskPb pb) async {
    final colorSet = <Color>{};
    for (final loop in pb.loop) {
      colorSet.addAll(loop.colorList.map((e) => e.color));
    }
    final colorList = colorSet.toList(); // 调色板

    final taskMessage = TaskMessage(
      colorList: colorList,
      cmykwList: colorList
          .map((e) => CMYKWUtil(mainStore.cmykwConfig).RGB_CMYG(e))
          .toList(),
      loop: pb.loop
          .map((e) => TaskLoop(
                colorList: e.colorList
                    .map((e) => colorList.indexOf(e.color) + 1)
                    .toList(),
                loopTime: e.loopTime,
              ))
          .toList(),
    );
    await sendData(taskMessage.toBytes());
  }

  Future<void> _sendV1Pause() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0xFF, 0x0, 0x0d, 0x0a];
    await sendData(data);
  }

  Future<void> _sendV1Start() async {
    final cmykw = mainStore.cmykw;
    final data = [
      cmykw.c,
      cmykw.y,
      cmykw.m,
      cmykw.k,
      cmykw.w,
      0x40,
      0x40,
      0xFF,
      0x1,
      0x0d,
      0x0a
    ];
    mainStore.sendColor();
    await sendData(data);
  }

  @action
  Future<void> _sendV1Pop() async {
    final data = [0, 0, 0, 0, 0, 0x40, 0x40, 0x0, 0xFF, 0x0d, 0x0a];
    await sendData(data);
  }

  @computed
  String get stateString {
    switch (state) {
      case ConnectState.Waiting:
        return '等待连接';
      case ConnectState.Scanning:
        return '扫描中';
      case ConnectState.Connecting:
        return '连接中';
      case ConnectState.DeviceNotFound:
        return '未发现设备';
      case ConnectState.TimeOut:
        return '连接超时';
      case ConnectState.Fail:
        return '连接失败';
      case ConnectState.Connected:
        return '已连接';
    }
  }

  Future<void> connectFindDevice(BluetoothDevice device) async {
    final devicesList = await FlutterBlue.instance.connectedDevices;
    if (!devicesList.contains(device)) {
      await device.connect(timeout: const Duration(seconds: 10));
    }
    final services = await device.discoverServices();
    final currentCharacteristic = findCharacteristic(services);
    if (currentCharacteristic != null) {
      characteristic = currentCharacteristic;
      connectedDevice = device;
      state = ConnectState.Connected;
    } else {
      await device.disconnect();
      throw Exception('没有找到合适的特征值');
    }
  }

  BluetoothCharacteristic? findCharacteristic(List<BluetoothService> services) {
    for (final service in services) {
      for (final c in service.characteristics) {
        if (c.uuid.toString().startsWith('0000ffe1')) {
          return c;
        }
      }
    }
  }
}
