import 'dart:async';
import 'dart:ui';

import 'package:aurora/data/model/ble_ext.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/page/task/store/task_maker_store.dart';
import 'package:aurora/utils/get_cmykw.dart';
import 'package:aurora/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobx/mobx.dart';

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
    await sendData(buildBluetooth(
      direction: MotorDirection.Forward,
      cmykw: mainStore.cmykw,
    ));
    mainStore.nowColor = mainStore.selectColor;
  }

  Future<void> sendStop() async {
    await sendData(buildBluetooth(
      direction: MotorDirection.Stop,
      cmykw: CMYKW.zero(),
    ));
  }

  Future<void> sendOut() async {
    await sendData(buildBluetooth(
      direction: MotorDirection.Reverse,
      cmykw: const CMYKW(
        c: 50,
        m: 50,
        y: 50,
        k: 50,
        w: 50,
      ),
    ));
  }

  Future<void> sendTask(TaskPb pb) async {
    final colorSet = <Color>{};
    for (final loop in pb.loop) {
      colorSet.addAll(loop.colorList.map((e) => e.color));
    }
    final colorList = colorSet.toList(); // 调色板

    final taskMessage = TaskMessage(
      colorList: colorList
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
    if (!devicesList.contains(device))
      await device.connect(timeout: const Duration(seconds: 10));
    final services = await device.discoverServices();
    BluetoothCharacteristic? currentCharacteristic;
    for (final service in services) {
      for (final c in service.characteristics) {
        if (c.properties.write &&
            c.properties.read &&
            c.properties.writeWithoutResponse &&
            c.descriptors.isNotEmpty) {
          currentCharacteristic = c;
        }
      }
    }
    if (currentCharacteristic != null) {
      characteristic = currentCharacteristic;
      connectedDevice = device;
      state = ConnectState.Connected;
    } else {
      await device.disconnect();
    }
  }
}
