import 'package:floor/floor.dart';

@Entity(tableName: 'TaskEntity')
class TaskEntity {
  TaskEntity({
    this.id,
    this.sort,
    required this.color,
    required this.c,
    required this.m,
    required this.y,
    required this.k,
    required this.w,
  });

  @PrimaryKey(autoGenerate: true)
  int? id;

  int? sort;
  final int color;
  final int c;
  final int m;
  final int y;
  final int k;
  final int w;
}
