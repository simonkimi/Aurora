import 'package:floor/floor.dart';

@entity
class ColorEntity {
  ColorEntity({required this.colorValue});
  @PrimaryKey(autoGenerate: true)
  int? id;

  int colorValue;
}
