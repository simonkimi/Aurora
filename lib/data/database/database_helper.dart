import 'package:blue_demo/data/database/entity/config_entity.dart';

import 'dao/config_dao.dart';
import 'dao/task_dao.dart';
import 'database.dart';

class DB {
  factory DB() => _db;

  DB._internal();

  static final DB _db = DB._internal();

  late AppDatabase _database;

  Future<void> init() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await addDefaultConfig();
  }

  Future<ConfigEntity?> addDefaultConfig() async {
    if ((await configDao.getAll()).isEmpty) {
      final config = ConfigEntity(
          name: 'default',
          G_kwM: 130.0,
          G_W_max: 204.0,
          G_K_min: 66.0,
          G_kw1: 73.0,
          Ka: 1507.0,
          Kb1: 70.65,
          Kb2: -5.63,
          Kc: 6.61,
          ts: 200,
          xy11: -0.295519,
          xy12: 0.093337,
          xy21: 0.316407,
          xy22: 0.323877,
          xy31: 0.408362,
          xy32: -0.637566);
      await configDao.addConfig(config);
      return config;
    }
    return null;
  }

  TaskDao get taskDao => _database.taskDao;

  ConfigDao get configDao => _database.configDao;
}
