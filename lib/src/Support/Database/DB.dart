import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:later_app/src/Support/Database/migrations/Migration.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _database;

  static final DB instance = DB._();

  DB._();

  Future<Database> get database async {

    if (_database != null){
      Logger().i('Database already initialized');
      return _database!;
    }

    _database = await _initDatabase();

    Logger().i('Database Initialized');
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join( await getDatabasesPath(), 'later_app.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        Logger().i('Creating database tables');
        for (var migration in Migration.migrations) {
          Logger().i('Running migration: ${migration.toString()}');
          db.execute(migration.up());
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    Logger().i('Creating database tables');
     for (var migration in  Migration.migrations) {
      Logger().i('Running migration: ${migration.toString()}');
         db.execute(migration.up());
    }
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> query(String table, {int limit = 10, int offset = 0, orderBy = 'creation_date DESC'}) async {
    final db = await database;
    return await db.query(
        'shared_content',
        limit: limit,
        offset: offset,
        orderBy: orderBy
    );
  }

  // Update Data
  Future<int> update(String table, Map<String, dynamic> values, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}

final SQLitedatabaseProvider = Provider<DB>((ref) {
  return DB.instance;
});
