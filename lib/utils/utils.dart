import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:aurora/main.dart';
import 'package:vibration/vibration.dart';

extension IntUtils on int {
  String toP() {
    final data = this / mainStore.cmykwConfig.ts * 100;
    if (data >= 100) return '100%';
    return (this / mainStore.cmykwConfig.ts * 100).toStringAsFixed(1) + '%';
  }

  String to3() {
    final n = (this * 1.5).round();
    if (n >= 100) return n.toString();
    return List.generate(3 - n.toString().length, (index) => '0').join('') +
        n.toString();
  }
}

extension StringHelper on String {
  String fill(String char, int num) {
    if (length >= num) return this;
    return List.filled(num - length, char).join() + this;
  }

  double toDouble() => double.parse(this);
}

extension IterableUtils<T> on Iterable<T> {
  T? get(bool test(T e)) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

extension StreamHelper<T> on Stream<T> {
  Stream<T> stopAfter(Duration duration) {
    final con = StreamController<T>();
    final listener = listen(con.add);
    Future.delayed(duration, () {
      listener.cancel();
      con.close();
    });
    return con.stream;
  }
}

extension ColorHelper on Color {
  bool isDark() => red * 0.299 + green * 0.578 + blue * 0.114 <= 192;
}

Future<void> vibrate({
  int duration = 100,
  List<int> pattern = const [],
  int repeat = -1,
  List<int> intensities = const [],
  int amplitude = -1,
}) async {
  if ((Platform.isIOS || Platform.isAndroid) &&
      (await Vibration.hasVibrator() ?? false)) {
    Vibration.vibrate(
      duration: duration,
      pattern: pattern,
      repeat: repeat,
      intensities: intensities,
      amplitude: amplitude,
    );
  }
}

String to16String(List<int> data) => data
    .map((e) => e.toRadixString(16))
    .map((e) => e.length == 1 ? '0$e' : e)
    .join(' ');

String to10String(List<int> data) => data.map((e) => e.toString()).join(' ');
