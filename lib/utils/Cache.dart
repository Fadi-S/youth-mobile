import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  SharedPreferences _instance;

  static Future<Cache> getInstance() async {
    SharedPreferences cache = await SharedPreferences.getInstance();
    return Cache._(cache);
  }

  Cache._(this._instance);

  Future<bool> setStringWithTime(String key, String value) {
    _instance.setInt(key + ".time", DateTime.now().millisecondsSinceEpoch);
    return _instance.setString(key, value);
  }

  String getStringIfBefore(String key, int differenceInSeconds) {
    int time = _instance.getInt(key + ".time");
    if(time == null) return null;
    DateTime oldTime = DateTime.fromMillisecondsSinceEpoch(time);

    if(oldTime.add(Duration(seconds: differenceInSeconds)).isAfter(DateTime.now()))
      return _instance.getString(key);

    return null;
  }

  String getString(String key) => _instance.getString(key);
  Future<bool> setString(String key, String value) => _instance.setString(key, value);

  Iterable getJSON(String key) {
    if(!_instance.containsKey(key))
      return null;

    return json.decode(_instance.getString(key));
  }
  Future<bool> setJSON(String key, dynamic value) => _instance.setString(key, json.encode(value));

  bool getBool(String key) => _instance.getBool(key);
  Future<bool> setBool(String key, bool value) => _instance.setBool(key, value);

  int getInt(String key) => _instance.getInt(key);
  Future<bool> setInt(String key, int value) => _instance.setInt(key, value);

  Future<bool> remove(String key) => _instance.remove(key);

  Future<bool> clear([String except]) {
    String saved = "";
    if(except != null)
      saved = getString(except);

    Future<bool> cleared = _instance.clear();

    _instance.setString(except, saved);
    return cleared;
  }

}
