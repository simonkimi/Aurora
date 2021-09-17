import 'package:blue_demo/main.dart';

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