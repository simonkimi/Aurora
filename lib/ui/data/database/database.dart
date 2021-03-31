import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:blue_demo/ui/data/database/entity/color_entity.dart';
import 'dao/color_dao.dart';
part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ColorEntity])
abstract class AppDataBase extends FloorDatabase {
  ColorDao get colorDao;
}
