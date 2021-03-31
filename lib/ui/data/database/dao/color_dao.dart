import 'package:blue_demo/ui/data/database/entity/color_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ColorDao {
  @Query('SELECT * FROM ColorEntity')
  Future<ColorEntity> getAll();

  @insert
  Future<int> add(ColorEntity entity);

  @delete
  Future<void> remove(ColorEntity entity);
}
