import 'package:moor/moor.dart';

// ignore_for_file: non_constant_identifier_names

class ConfigTable extends Table {
  TextColumn get name => text()();

  BlobColumn get pb => blob()();

  @override
  Set<Column> get primaryKey => {name};
}
