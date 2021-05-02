import 'package:blue_demo/data/database/entity/task_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM TaskEntity ORDER BY id ASC')
  Future<List<TaskEntity>> getAll();

  @insert
  Future<int> addTask(TaskEntity entity);

  @update
  Future<int> updateTask(TaskEntity entity);

  @delete
  Future<void> deleteTask(TaskEntity entity);
}
