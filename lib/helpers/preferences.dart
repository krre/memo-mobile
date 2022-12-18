import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../db/database.dart';

const _dbKey = 'db';

class Preferences {
  static Future<void> setDbName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_dbKey, name);
  }

  static Future<String?> getDbName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_dbKey);

    if (name == null) return null;

    String path = await Db.nameToPath(name);

    if (await File(path).exists()) {
      return name;
    }

    prefs.remove(_dbKey);
    return null;
  }

  static Future<void> clearDbName() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_dbKey);
  }
}
