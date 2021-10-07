import 'package:moor/moor.dart';

class TaskTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  BlobColumn get taskPb => blob()();
}
