import 'dart:async';
import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/task_dao.dart';
import 'entity/task_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [TaskEntity])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
}
