import 'dart:async';
import 'package:aurora/main.dart';
import 'package:aurora/utils/get_cmykw.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'gradient_store.g.dart';

class GradientStore = GradientStoreBase with _$GradientStore;

abstract class GradientStoreBase with Store {
  GradientStoreBase() {
    genHlsColorList();
  }

  @observable
  Color startRgb = Colors.blue;

  @observable
  Color endRgb = Colors.red;

  @observable
  double startH = 0.0;

  @observable
  double startS = 1.0;

  @observable
  double startL = 0.75;

  @observable
  double endH = 360.0;

  @observable
  double endS = 1.0;

  @observable
  double endL = 0.75;

  @observable
  int step = 100;

  @observable
  int timer = 10;

  ObservableList<Color> colorList = ObservableList<Color>();

  @observable
  int currentStep = 0;

  @observable
  bool isLock = false;

  StreamSubscription? timerListener;

  void startSend() {
    if (bluetoothStore.isConnected) {
      isLock = true;
      timerListener = Stream.periodic(Duration(seconds: timer)).listen((event) {
        final color = colorList[currentStep];
        final cmykw = CMYKWUtil(mainStore.cmykwConfig).RGB_CMYG(color);
        mainStore.nowColor = color;
        bluetoothStore.sendCmykw(cmykw, color);
        if (currentStep + 1 >= colorList.length) {
          stopSend();
          return;
        }
        currentStep += 1;
      });
    } else {
      BotToast.showText(text: '设备未连接');
    }
  }

  void stopSend() {
    isLock = false;
    timerListener?.cancel();
  }

  @action
  void genHlsColorList() {
    currentStep = 0;
    colorList.clear();
    colorList.addAll(List.generate(step, (index) {
      final h = genStep(startH, endH, index);
      final s = genStep(startS, endS, index);
      final l = genStep(startL, endL, index);
      return hsl2rgb(h: h, s: s, l: l);
    }));
  }

  @action
  void genRgbColorList() {
    currentStep = 0;
    colorList.clear();
    colorList.addAll(List.generate(step, (index) {
      final r = genStep(startRgb.red.toDouble(), endRgb.red.toDouble(), index)
          .floor();
      final g =
          genStep(startRgb.green.toDouble(), endRgb.green.toDouble(), index)
              .floor();
      final b = genStep(startRgb.blue.toDouble(), endRgb.blue.toDouble(), index)
          .floor();
      return Color.fromARGB(0xff, r, g, b);
    }));
  }

  double genStep(double start, double end, int n) =>
      start + (end - start) / step * n;

  Color hsl2rgb({
    required double h,
    required double s,
    required double l,
  }) {
    if (s > 0) {
      const v_1_3 = 1.0 / 3;
      const v_1_6 = 1.0 / 6;
      const v_2_3 = 2.0 / 3;

      final q = l < 0.5 ? l * (1 + s) : l + s - (l * s);
      final p = l * 2 - q;
      final hk = h / 360.0;
      final tr = hk + v_1_3;
      final tg = hk;
      final tb = hk - v_1_3;

      final rgb1 = [tr, tg, tb].map((tc) => tc < 0
          ? tc + 1.0
          : tc > 1
              ? tc - 1.0
              : tc);

      final rgb2 = rgb1.map((tc) => tc < v_1_6
          ? p + ((q - p) * 6 * tc)
          : v_1_6 <= tc && tc < 0.5
              ? q
              : 0.5 <= tc && tc < v_2_3
                  ? p + ((q - p) * 6 * (v_2_3 - tc))
                  : p);

      final rgb3 = rgb2.map((e) => (e * 255).floor()).toList();

      return Color.fromARGB(0xff, rgb3[0], rgb3[1], rgb3[2]);
    } else {
      return Color.fromARGB(0xff, l.round(), l.round(), l.round());
    }
  }
}
