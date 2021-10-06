// import 'package:aurora/data/database/entity/config_entity.dart';
// import 'package:floor/floor.dart';
//
//
// abstract class ConfigDao {
//   @Query('SELECT * FROM ConfigEntity ORDER BY id ASC')
//   Future<List<ConfigEntity>> getAll();
//
//   @Query('SELECT * FROM ConfigEntity ORDER BY id ASC')
//   Stream<List<ConfigEntity>> getAllStream();
//
//   @Query('SELECT * FROM ConfigEntity WHERE name = :name')
//   Future<ConfigEntity?> get(String name);
//
//   @Insert(onConflict: OnConflictStrategy.replace)
//   Future<int> addConfig(ConfigEntity entity);
//
//   @update
//   Future<int> updateConfig(ConfigEntity entity);
//
//   @Query('DELETE FROM ConfigEntity WHERE name = :name')
//   Future<void> deleteConfig(String name);
// }

import 'package:aurora/data/database/entity/config_table.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'config_dao.g.dart';

@UseDao(tables: [ConfigTable])
class ConfigDao extends DatabaseAccessor<MyDatabase> with _$ConfigDaoMixin {
  ConfigDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<ConfigTableData>> getAll() => select(configTable).get();

  Future<ConfigTableData?> get(String name) =>
      (select(configTable)..where((tbl) => tbl.name.equals(name)))
          .getSingleOrNull();

  Future<void> addConfig(ConfigTableCompanion config) =>
      into(configTable).insert(config);

  Future<void> deleteConfig(String name) =>
      (delete(configTable)..where((tbl) => tbl.name.equals(name))).go();

  Stream<List<ConfigTableData>> getAllStream() => select(configTable).watch();
}
