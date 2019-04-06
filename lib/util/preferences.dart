import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Preferences {

  static Future<String> getString(String key) async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static void setString(String key, String value) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

}
