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

  Future<void> remove(ConfigTableData entity) =>
      delete(configTable).delete(entity);

  Stream<List<ConfigTableData>> getAllStream() => select(configTable).watch();
}
