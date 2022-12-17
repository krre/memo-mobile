import 'dart:io';

import 'package:memo/db/migrater.dart' as migrater;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/preferences.dart';

class Db {
  static Db? _instance;
  late Database _db;

  static Db getInstance() {
    _instance ??= Db();
    return _instance!;
  }

  void create(String name) async {
    var databasesPath = await getDatabasesPath();
    await Directory(databasesPath).create(recursive: true);
    String path = join(databasesPath, '$name.db');

    await deleteDatabase(path);
    open(path);

    Preferences.setDbPath(path);
  }

  void open(String path) async {
    _db = await openDatabase(path, version: migrater.version,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE notes("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "parent_id INTEGER,"
          "pos INTEGER,"
          "depth INTEGER,"
          "title TEXT,"
          "note TEXT,"
          "line INTEGER,"
          "created_at TIMESTAMP DEFAULT (datetime('now', 'localtime')),"
          "updated_at TIMESTAMP DEFAULT (datetime('now', 'localtime')))");
    });
  }
}
