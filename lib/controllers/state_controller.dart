import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateController extends GetxController {
  late int textSize;
  late int speed;
  static const String speedkey = 'speedKey';
  static const String sizekey = 'sizekey';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    textSize = getSize()!;
    speed = getSpeed()!;
  }

  final Map<int, Map<String, int>> speedsMap = {
    100: {
      'short': 550,
      'medium': 600,
      'long': 700,
    },
    150: {
      'short': 350,
      'medium': 400,
      'long': 500,
    },
    200: {
      'short': 250,
      'medium': 300,
      'long': 400,
    },
    250: {
      'short': 190,
      'medium': 240,
      'long': 340,
    },
    300: {
      'short': 150,
      'medium': 200,
      'long': 300,
    },
    350: {
      'short': 140,
      'medium': 170,
      'long': 270,
    },
    400: {
      'short': 120,
      'medium': 150,
      'long': 250,
    },
  };

  Future<void> setSpeed(int spd) {
    return prefs.setInt(speedkey, spd);
  }

  Future<void> setSize(int size) {
    return prefs.setInt(sizekey, size);
  }

  int? getSize() {
    return prefs.containsKey(sizekey) ? prefs.getInt(sizekey) : 40;
  }

  int? getSpeed() {
    return prefs.containsKey(speedkey) ? prefs.getInt(speedkey) : 200;
  }
}
