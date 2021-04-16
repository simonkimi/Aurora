import 'package:blue_demo/data/database/entity/task_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM HistoryEntity ORDER BY createTime DESC')
  Future<List<TaskEntity>> getAll();

  @insert
  Future<int> addHistory(TaskEntity entity);
}
