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
      await db.transaction((txn) async {
        txn.execute("""
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parent_id INTEGER,
            remote_id INTEGER,
            pos INTEGER,
            depth INTEGER,
            title TEXT,
            note TEXT,
            line INTEGER,
            created_at TIMESTAMP DEFAULT (datetime('now', 'localtime')),
            updated_at TIMESTAMP DEFAULT (datetime('now', 'localtime'))
          );
        """);

        txn.execute("""
          CREATE TABLE meta(
            version INTEGER,
            selected_id INTEGER,
            remote_database TEXT
          );
        """);

        txn.execute("""
          INSERT INTO meta (version, selected_id, remote_database) VALUES (1, 0, '{}');
        """);
      });
    });
    _isOpen = true;
    await Preferences.setDbName(name);
  }

  Future<Id> insertNote(Id parentId, int pos, int depth, String title) async {
    return await _db.rawInsert(
        'INSERT INTO notes (parent_id, pos, depth, title) VALUES (?, ?, ?, ?)',
        [parentId, pos, depth, title]);
  }

  Future<Id> insertRemoteNote(
      Id id, Id parentId, int pos, int depth, String title, String note) async {
    return await _db.rawInsert(
        'INSERT INTO notes (id, parent_id, pos, depth, title, note) VALUES (?, ?, ?, ?, ?, ?)',
        [id, parentId, pos, depth, title, note]);
  }

  Future<List<Map<String, Object?>>> getTitles() async {
    return await _db.rawQuery(
        'SELECT id, parent_id, pos, depth, title FROM notes ORDER BY depth, pos');
  }

  Future<void> deleteNote(Id id) async {
    await _db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
  }

  Future<void> updateValue(Id id, String name, dynamic value) async {
    String updateDate =
        name == 'note' ? ", updated_at = datetime('now', 'localtime')" : '';
    await _db.rawUpdate(
        'UPDATE notes SET $name = ? $updateDate WHERE id = ?', [value, id]);
  }

  Future<dynamic> getValue(Id id, String name) async {
    final rows =
        await _db.rawQuery('SELECT $name FROM notes WHERE id = ?', [id]);
    return rows.first[name];
  }
}
