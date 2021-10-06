// import 'package:blue_demo/data/database/entity/task_entity.dart';
// import 'package:floor/floor.dart';
//
// @dao
// abstract class TaskDao {
//   @Query('SELECT * FROM TaskEntity ORDER BY id ASC')
//   Future<List<TaskEntity>> getAll();
//
//   @insert
//   Future<int> addTask(TaskEntity entity);
//
//   @update
//   Future<int> updateTask(TaskEntity entity);
//
//   @delete
//   Future<void> deleteTask(TaskEntity entity);
// }

import 'package:blue_demo/data/database/entity/task_table.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'task_dao.g.dart';

@UseDao(tables: [TaskTable])
class TaskDao extends DatabaseAccessor<MyDatabase>
    with _$TaskDaoMixin {
  TaskDao(MyDatabase attachedDatabase) : super(attachedDatabase);


}