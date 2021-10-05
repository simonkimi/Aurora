import 'package:floor/floor.dart';

// ignore_for_file: non_constant_identifier_names

@Entity(tableName: 'ConfigEntity')
class ConfigEntity {
  ConfigEntity({
    required this.name,
    this.G_K_min = 66.0,
    this.G_kw1 = 73.0,
    this.G_kwM = 130.0,
    this.G_W_max = 204.0,
    this.Ka = 1507.0,
    this.Kb1 = 70.65,
    this.Kb2 = -5.63,
    this.Kc = 6.61,
    this.ts = 200,
    this.xy11 = -0.295519,
    this.xy12 = 0.093337,
    this.xy21 = 0.316407,
    this.xy22 = 0.323877,
    this.xy31 = 0.408362,
    this.xy32 = -0.637566,
  });

  @PrimaryKey(autoGenerate: true)
  int? id;

  @primaryKey
  String name;

  double G_kwM; //最灰色值
  double G_W_max; //最白色值
  double G_K_min; //最黑色值
  double G_kw1; //黑阶分界值
  double Ka; //拟合参数a
  double Kb1; //拟合参数b1
  double Kb2; //拟合参数b2
  double Kc; //拟合参数c
  double ts;

  double xy11;
  double xy12;
  double xy21;
  double xy22;
  double xy31;
  double xy32;
}
