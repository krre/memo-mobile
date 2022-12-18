import 'dart:io';

import 'package:memo/db/migrater.dart' as migrater;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../globals.dart';
import '../helpers/preferences.dart';

class DatabaseExistsException implements Exception {
  late final String name;

  DatabaseExistsException(this.name);

  @override
  String toString() {
    return 'Database exists witn name $name';
  }
}

class Db {
  static Db? _instance;
  late Database _db;
  bool _isOpen = false;

  static Db getInstance() {
    _instance ??= Db();
    return _instance!;
  }

  static Future<String> nameToPath(String name) async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, '$name.db');
  }

  bool isOpen() {
    return _isOpen;
  }

  Future<void> create(String name, {bool overwrite = false}) async {
    var databasesPath = await getDatabasesPath();
    await Directory(databasesPath).create(recursive: true);
    String path = await nameToPath(name);

    if (await File(path).exists() && !overwrite) {
      throw DatabaseExistsException(name);
    }

    await deleteDatabase(path);
    await open(name);
  }

  Future<void> open(String name) async {
    String path = await nameToPath(name);
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

    _isOpen = true;
    await Preferences.setDbName(name);
  }

  Future<Id> insertNote(Id parentId, int pos, int depth, String title) async {
    return await _db.rawInsert(
        'INSERT INTO notes (parent_id, pos, depth, title) VALUES (?, ?, ?, ?)',
        [parentId, pos, depth, title]);
  }

  Future<List<Map<String, Object?>>> getTitles() async {
    return await _db.rawQuery(
        'SELECT id, parent_id, pos, depth, title FROM notes ORDER BY depth, pos');
  }
}
