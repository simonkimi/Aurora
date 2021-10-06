import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:blue_demo/main.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobx/mobx.dart';

part 'monitor_store.g.dart';

class MonitorStore = MonitorStoreBase with _$MonitorStore;

abstract class MonitorStoreBase with Store {
  final limitCount = 100;
  final colorDeltaE = ObservableList<FlSpot>();
  var timeLine = 0.0;

  @observable
  Color nowColor = mainStore.selectColor;

  String? ip;

  StreamSubscription? listener;

  Future<void> loadLine() async {
    listener = Stream.periodic(const Duration(milliseconds: 500))
        .listen((event) async {
      try {
        if (ip != null) {
          final rsp = await Dio().get<String>('http://$ip:8888/color');
          final color = rsp.data!.split('|').map((e) => int.parse(e)).toList();

          final r = color[0];
          final g = color[1];
          final b = color[2];
          nowColor = Color.fromARGB(0xFF, r, g, b);
          final targetColor = mainStore.selectColor;
          while (colorDeltaE.length > limitCount) {
            colorDeltaE.removeAt(0);
          }

          final value = pow(
              ((r - targetColor.red).abs() +
                      (g - targetColor.green).abs() +
                      (b - targetColor.blue).abs()) /
                  50,
              0.5) as double;

          colorDeltaE.add(FlSpot(timeLine, value));
          timeLine += 1;
        }
      } catch (e) {
        print('cache $e');
      }
    });
  }

  void dispose() {
    listener?.cancel();
  }
}
