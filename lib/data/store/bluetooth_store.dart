import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobx/mobx.dart';

import '../constant.dart';

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

abstract class BluetoothStoreBase with Store {
  @observable
  bool isScanning = false;

  @observable
  BluetoothDevice? connectedDevice;

  @observable
  BluetoothCharacteristic? characteristic;

  @observable
  ConnectState state = ConnectState.Waiting;

  Future<void> sendData(List<int> data) async {
    if (connectedDevice != null && characteristic != null) {
      await characteristic!.write(data, withoutResponse: false);
      print(
          '发送数据: ${data.map((e) => e.toRadixString(16)).map((e) => e.length == 1 ? '0$e' : e).join(' ')}');
      print('发送数据: ${data.map((e) => e.toString()).join(' ')}');
      return;
    }
    throw DeviceNotConnectException();
  }

  Future<void> setBleListen() async {
    await characteristic!.setNotifyValue(true);
    characteristic!.value.listen((event) {
      print('收到数据: $event');
    });
  }


  // Future<void>



  // 寻找并且连接设备
  @action
  Future<void> findAndConnect() async {
    StreamSubscription<bool>? scanListener;
    StreamSubscription<List<ScanResult>>? resultListener;

    state = ConnectState.Scanning;

    try {
      final adapter = FlutterBlue.instance;
      final connectedData = await adapter.connectedDevices;
      final data =
          connectedData.where((element) => element.id.id == HC08_MAC).toList();
      if (data.isNotEmpty) {
        // 当前设备已经连接, 获取设备状态
        state = ConnectState.Waiting;
        await connectDevice(data[0], true);
      } else {
        // 当前设备未连接
        adapter.startScan(timeout: const Duration(seconds: 10));
        final deviceCompleter = Completer<BluetoothDevice>();
        resultListener = adapter.scanResults.listen((event) {
          for (final element in event) {
            if (element.device.id.id == HC08_MAC) {
              print(element.device.id.id);
              if (!deviceCompleter.isCompleted) {
                deviceCompleter.complete(element.device);
              }
            }
          }
        });
        await Future.delayed(const Duration(seconds: 1));
        scanListener = adapter.isScanning.listen((event) {
          print(event);
          if (event) {
            state = ConnectState.Scanning;
          } else {
            if (!deviceCompleter.isCompleted) {
              deviceCompleter.completeError(Exception('没有发现设备'));
            }
          }
        });
        final device = await deviceCompleter.future;
        print('扫描设备完成, 设备:${device.name}');
        await connectDevice(device);
      }
    } on Exception catch (e) {
      state = ConnectState.Fail;
      BotToast.showText(text: e.toString());
      rethrow;
    } finally {
      scanListener?.cancel();
      resultListener?.cancel();
    }
  }

  @action
  Future<void> connectDevice(BluetoothDevice device,
      [bool isConnect = false]) async {
    try {
      if (!isConnect) {
        print('设备未连接, 准备连接...');
      }
      await device.connect(timeout: const Duration(seconds: 10));
      connectedDevice = device;
      final service = await device.discoverServices();

      for (final element in service) {
        if (element.uuid.toString() == BLE_SERVICE_UUID) {
          for (final device in element.characteristics) {
            if (device.uuid.toString() == BLE_READ_WRITE_UUID) {
              characteristic = device;
            }
          }
        }
      }

      await FlutterBlue.instance.stopScan();
      // setHint('连接成功!');
      state = ConnectState.Connected;
      if (characteristic == null) {
        throw Exception('没有找到蓝牙对应的服务!');
      }
      setBleListen();
    } on TimeoutException {
      state = ConnectState.TimeOut;
      throw Exception('蓝牙连接超时');
    }
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
}
