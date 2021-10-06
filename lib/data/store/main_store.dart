import 'dart:async';
import 'dart:ui';
import 'package:blue_demo/data/database/database.dart';
import 'package:blue_demo/data/database/database_helper.dart';
import 'package:blue_demo/utils/get_cmykw.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main_store.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store {
  @observable
  Color selectColor = Colors.blue;

  @observable
  Color? nowColor;

  @observable
  var cmykw = const CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @observable
  var nowCmykw = const CMYKW(c: 0, m: 0, y: 0, k: 0, w: 0);

  @observable
  var cmykwConfig = CMYKWConfig();

  @action
  Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    final color = pref.getInt('color') ?? Colors.blue.value;
    selectColor = Color(color | 0xFF000000);
    nowColor = selectColor;

    final configName = pref.getString('cmykwConfig');

    if (configName == null) {
      await setCmykwConfig((await DB().configDao.getAll()).first);
    } else {
      final entity = await DB().configDao.get(configName);
      await setCmykwConfig(entity ?? (await DB().configDao.getAll()).first);
    }

    cmykw = CMYKWUtil(cmykwConfig).RGB_CMYG(selectColor);

    Stream.periodic(const Duration(seconds: 2)).listen((event) async {
      final pref = await SharedPreferences.getInstance();
      pref.setInt('color', selectColor.value);
    });
  }

  @action
  Future<void> setCmykwConfig(ConfigTableData entity) async {
    cmykwConfig = CMYKWConfig.database(entity);
    cmykw = CMYKWUtil(cmykwConfig).RGB_CMYG(selectColor);
    final pref = await SharedPreferences.getInstance();
    pref.setString('cmykwConfig', entity.name);
  }

  @action
  Future<void> setColor(Color color) async {
    selectColor = Color(color.value | 0xFF000000);
    cmykw = CMYKWUtil(cmykwConfig).RGB_CMYG(color);
  }
}
