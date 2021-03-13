import 'dart:async';
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

  @action
  Future<bool> connectDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: Duration(seconds: 10));
    } on TimeoutException {
      return false;
    }
    connectedDevice = device;
    return true;
  }
}
