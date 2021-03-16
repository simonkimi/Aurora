import 'package:blue_demo/ui/data/store/constant.dart';

extension IntUtils on int {
  String get toP => (this / M_TS * 100).toStringAsFixed(1) + '%';

  String to3() {
    if (this >= 100) return this.toString();
    return List.generate(3 - this.toString().length, (index) => '0').join('') +
        this.toString();
  }
}
