


import 'package:later_app/src/Support/Database/migrations/CreateSharedContentTable.dart';

abstract class Migration {
  String up();

  static List<Migration> get migrations => [
    CreateSharedContentTable()
  ];
}