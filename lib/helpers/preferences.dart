import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static void setDbPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("db", path);
  }

  static Future<String?> getDbPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("db");
  }

  static Future<bool> dbExists() async {
    var path = await getDbPath();
    if (path == null) return false;

    // Test on db exists

    return true;
  }
}
