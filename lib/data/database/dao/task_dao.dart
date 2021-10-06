import 'package:aurora/data/database/entity/task_table.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'task_dao.g.dart';

@UseDao(tables: [TaskTable])
class TaskDao extends DatabaseAccessor<MyDatabase> with _$TaskDaoMixin {
  TaskDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<TaskTableData>> getAllStream() => select(taskTable).watch();
}
