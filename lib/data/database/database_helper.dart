import 'package:aurora/data/proto/gen/config.pbserver.dart';

import 'dao/config_dao.dart';
import 'dao/task_dao.dart';
import 'database.dart';

class DB {
  factory DB() => _db;

  DB._internal();

  static final DB _db = DB._internal();

  final MyDatabase _database = MyDatabase();

  Future<void> addDefaultConfig() async {
    if ((await configDao.getAll()).isEmpty) {
      final config = ConfigTableCompanion.insert(
        name: 'default',
        pb: CMYKWConfigPB(
          name: 'default',
          gKwM: 130.0,
          gWMax: 204.0,
          gKMin: 66.0,
          gKw1: 73.0,
          ka: 1507.0,
          kb1: 70.65,
          kb2: -5.63,
          kc: 6.61,
          ts: 200,
          xy11: -0.295519,
          xy12: 0.093337,
          xy21: 0.316407,
          xy22: 0.323877,
          xy31: 0.408362,
          xy32: -0.637566,
          platformSpeed: 50
        ).writeToBuffer(),
      );
      await configDao.addConfig(config);
    }
  }

  TaskDao get taskDao => _database.taskDao;

  ConfigDao get configDao => _database.configDao;
}
