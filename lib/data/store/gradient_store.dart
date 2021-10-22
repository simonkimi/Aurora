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

  ObservableList<Color> rgbList =
      ObservableList.of([Colors.blue, Colors.cyan, Colors.green]);

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

  void addRgb(Color color) {
    rgbList.add(color);
  }

  void removeRgb(int index) {
    rgbList.removeAt(index);
  }

  void startSend() {
    if (bluetoothStore.isConnected) {
      isLock = true;
      timerListener =
          Stream.periodic(Duration(seconds: timer)).listen(_sendColor);
      _sendColor(null);
    } else {
      BotToast.showText(text: '设备未连接');
    }
  }

  void _sendColor(_) {
    final color = colorList[currentStep];
    final cmykw = CMYKWUtil(mainStore.cmykwConfig).RGB_CMYG(color);
    mainStore.nowColor = color;
    bluetoothStore.sendCmykw(cmykw, color);
    if (currentStep + 1 >= colorList.length) {
      stopSend();
      return;
    }
    currentStep += 1;
  }

  void stopAndBreak() {
    stopSend();
    bluetoothStore.sendStop();
  }

  void stopSend() {
    isLock = false;
    timerListener?.cancel();
    timerListener = null;
  }

  @action
  void genHlsColorList() {
    if (step > 0) {
      currentStep = 0;
      colorList.clear();
      colorList.addAll(List.generate(step, (index) {
        final h = genStep(startH, endH, step, index);
        final s = genStep(startS, endS, step, index);
        final l = genStep(startL, endL, step, index);
        return hsl2rgb(h: h, s: s, l: l);
      }));
    }
  }

  @action
  void genRgbColorList() {
    if (rgbList.isNotEmpty && step > rgbList.length) {
      currentStep = 0;
      colorList.clear();
      final eachStep = step ~/ (rgbList.length - 1);
      for (var i = 0; i < rgbList.length - 1; i++) {
        colorList.addAll(List.generate(eachStep, (index) {
          final startRgb = rgbList[i];
          final endRgb = rgbList[i + 1];

          final r = genStep(startRgb.red.toDouble(), endRgb.red.toDouble(),
                  eachStep, index)
              .floor();
          final g = genStep(startRgb.green.toDouble(), endRgb.green.toDouble(),
                  eachStep, index)
              .floor();
          final b = genStep(startRgb.blue.toDouble(), endRgb.blue.toDouble(),
                  eachStep, index)
              .floor();
          return Color.fromARGB(0xff, r, g, b);
        }));
      }
    }
  }

  double genStep(double start, double end, int step, int n) =>
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

      final rgb = [tr, tg, tb]
          .map((tc) => tc < 0
              ? tc + 1.0
              : tc > 1
                  ? tc - 1.0
                  : tc)
          .map((tc) => tc < v_1_6
              ? p + ((q - p) * 6 * tc)
              : v_1_6 <= tc && tc < 0.5
                  ? q
                  : 0.5 <= tc && tc < v_2_3
                      ? p + ((q - p) * 6 * (v_2_3 - tc))
                      : p)
          .map((e) => (e * 255).floor())
          .toList();

      return Color.fromARGB(0xff, rgb[0], rgb[1], rgb[2]);
    } else {
      return Color.fromARGB(0xff, l.round(), l.round(), l.round());
    }
  }
}
