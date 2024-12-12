

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {

  // create a singleton class to open sqlite database connection
  static final DB _instance = DB._internal();
  factory DB() => _instance;

  static Database? _database;

  DB._internal();

  // open the database connection
  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'later_app.db'),

      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE content(id INTEGER PRIMARY KEY, link TEXT)',
        );
      },

      version: 1,
    );

    return _database!;
  }

  Future<void> insertDog( String link) async {
    final db = await database;

    await db.insert(
      'content',
      {
        'link': link,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


}