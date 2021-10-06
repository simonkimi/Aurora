import 'package:moor/moor.dart';

// ignore_for_file: non_constant_identifier_names

class ConfigTable extends Table {
  TextColumn get name => text()();

  RealColumn get G_kwM => real()(); //最灰色值
  RealColumn get G_W_max => real()(); //最白色值
  RealColumn get G_K_min => real()(); //最黑色值
  RealColumn get G_kw1 => real()(); //黑阶分界值
  RealColumn get Ka => real()(); //拟合参数a
  RealColumn get Kb1 => real()(); //拟合参数b1
  RealColumn get Kb2 => real()(); //拟合参数b2
  RealColumn get Kc => real()(); //拟合参数c
  RealColumn get ts => real()();

  RealColumn get xy11 => real()();

  RealColumn get xy12 => real()();

  RealColumn get xy21 => real()();

  RealColumn get xy22 => real()();

  RealColumn get xy31 => real()();

  RealColumn get xy32 => real()();

  @override
  Set<Column> get primaryKey => {name};
}
