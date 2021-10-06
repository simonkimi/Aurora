import 'package:floor/floor.dart';

@Entity(tableName: 'TaskEntity')
class TaskEntity {
  TaskEntity({
    this.id = 1,
  });

  @PrimaryKey(autoGenerate: true)
  int id;
}
