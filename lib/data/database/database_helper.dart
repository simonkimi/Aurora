import 'dao/task_dao.dart';
import 'database.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _databaseHelper;

  DatabaseHelper._internal();

  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  late AppDatabase _database;

  Future<void> init() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  TaskDao get taskDao => _database.taskDao;
}
