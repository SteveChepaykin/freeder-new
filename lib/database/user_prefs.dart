import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String speedkey = 'speedKey';
  static const String sizekey = 'sizekey';

  late final SharedPreferences prefs;

  Future<void> setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Future<void> setSpeed(int spd) {
  //   return prefs.setInt(speedkey, spd);
  // }

  // Future<void> setSize(int size) {
  //   return prefs.setInt(sizekey, size);
  // }

  // int? getSize() {
  //   return prefs.containsKey(sizekey) ? prefs.getInt(sizekey) : 40;
  // }
  // int? getSpeed() {
  //   return prefs.containsKey(speedkey) ? prefs.getInt(speedkey) : 4;
  // }
}