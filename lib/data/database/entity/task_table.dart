import 'package:moor/moor.dart';

class TaskTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  BlobColumn get taskPb => blob()();
}
