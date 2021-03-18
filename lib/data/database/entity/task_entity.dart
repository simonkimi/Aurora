import 'package:floor/floor.dart';

@Entity(tableName: 'TaskEntity')
class TaskEntity {
  TaskEntity([this.id, this.delay, this.color, this.title]);
  @PrimaryKey(autoGenerate: true)
  final int id;

  final int delay;
  final int color;
  final String title;
}
