import 'package:blue_demo/data/database/entity/config_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConfigDao {
  @Query('SELECT * FROM ConfigEntity ORDER BY id ASC')
  Future<List<ConfigEntity>> getAll();

  @Query('SELECT * FROM ConfigEntity ORDER BY id ASC')
  Stream<List<ConfigEntity>> getAllStream();

  @Query('SELECT * FROM ConfigEntity WHERE name = :name')
  Future<ConfigEntity?> get(String name);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> addConfig(ConfigEntity entity);

  @update
  Future<int> updateConfig(ConfigEntity entity);

  @Query('DELETE FROM ConfigEntity WHERE name = :name')
  Future<void> deleteConfig(String name);
}
