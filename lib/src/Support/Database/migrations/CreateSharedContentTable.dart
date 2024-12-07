

import 'package:later_app/src/Support/Database/migrations/Migration.dart';

class CreateSharedContentTable extends Migration {
  @override
  String up() {
    return '''
      CREATE TABLE shared_content (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        image,
        url TEXT
      )
    ''';
  }

}