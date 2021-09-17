import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/config_dao.dart';
import 'dao/task_dao.dart';
import 'entity/config_entity.dart';
import 'entity/task_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [TaskEntity, ConfigEntity])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
  ConfigDao get configDao;
}
