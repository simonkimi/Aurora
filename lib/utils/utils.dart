import 'package:blue_demo/ui/data/store/constant.dart';

extension IntUtils on int {
  String toP() {
    final data = (this / M_TS * 100);
    if (data >= 100) return '100%';
    return (this / M_TS * 100).toStringAsFixed(1) + '%';
  }

  String to3() {
    final n = (this * 1.5).round();
    if (n >= 100) return n.toString();
    return List.generate(3 - n.toString().length, (index) => '0').join('') +
        this.toString();
  }
}