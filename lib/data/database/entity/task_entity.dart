import 'package:floor/floor.dart';

@Entity(tableName: 'TaskEntity')
class TaskEntity {
  TaskEntity(
      {required this.id,
      required this.delay,
      required this.color,
      required this.title});

  @PrimaryKey(autoGenerate: true)
  final int id;

  final int delay;
  final int color;
  final String title;
}
