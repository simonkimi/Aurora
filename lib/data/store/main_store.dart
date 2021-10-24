import 'dart:async';
import 'dart:ui';
import 'package:aurora/data/database/database_helper.dart';
import 'package:aurora/data/proto/gen/config.pbserver.dart';
import 'package:aurora/utils/event_bus.dart';
import 'package:aurora/utils/get_cmykw.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

enum MessageVersion { V1, V3 }

abstract class MainStoreBase with Store {
  @observable
  Color selectColor = Colors.grey;

  @observable
  Color? nowColor;

  @observable
  var cmykw = const CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @observable
  var nowCmykw = const CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @observable
  var cmykwConfig = CMYKWConfigPB();

  @observable
  var version = MessageVersion.V3;

  @action
  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor = Color(color | 0xFF000000);
    nowColor = selectColor;

    final configName = pref.getString('cmykwConfig');

    final defaultConfig = (await DB().configDao.getAll()).first;

    if (configName == null) {
      await setCmykwConfig(CMYKWConfigPB.fromBuffer(defaultConfig.pb));
    } else {
      final entity = await DB().configDao.get(configName);
      if (entity == null) {
        await setCmykwConfig(CMYKWConfigPB.fromBuffer(defaultConfig.pb));
      } else {
        await setCmykwConfig(CMYKWConfigPB.fromBuffer(entity.pb));
      }
    }

    Stream.periodic(const Duration(seconds: 2)).listen((event) async {
      final pref = await SharedPreferences.getInstance();
      pref.setInt('color', selectColor.value);
    });

    Bus().on<EventBleSpeed>().listen((EventBleSpeed event) {
      nowColor = Color.fromARGB(0xff, event.r, event.g, event.b);
      nowCmykw =
          CMYKW(c: event.c, m: event.m, y: event.y, k: event.k, w: event.w);
    });
  }

  @action
  Future<void> setCmykwConfig(CMYKWConfigPB entity) async {
    cmykwConfig = entity;
    cmykw = CMYKWUtil(entity).RGB_CMYG(selectColor);
    final pref = await SharedPreferences.getInstance();
    pref.setString('cmykwConfig', entity.name);
  }

  @action
  Future<void> setColor(Color color) async {
    selectColor = Color(color.value | 0xFF000000);
    cmykw = CMYKWUtil(cmykwConfig).RGB_CMYG(color);
  }

  @action
  void sendColor() {
    nowColor = selectColor;
  }
}
