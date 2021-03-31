import 'package:blue_demo/ui/data/database/dao/color_dao.dart';

import 'database.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final _instance = DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  late AppDataBase _dataBase;

  Future<void> init() async {
    _dataBase = await $FloorAppDataBase.databaseBuilder('database.db').build();
  }

  ColorDao get colorDao => _dataBase.colorDao;
}
