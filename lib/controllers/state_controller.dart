import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freeder_new/utils/logger.dart';

class StateController extends GetxController {
  final log = getLogger('StateController');
  late int textSize;
  late int speed;
  static const String speedkey = 'speedKey';
  static const String sizekey = 'sizekey';

  late final SharedPreferences prefs;

  Future<void> init() async {
    log.info('Initializing state controller');
    prefs = await SharedPreferences.getInstance();
    textSize = getSize()!;
    speed = getSpeed()!;
    log.info('State initialized with textSize: $textSize, speed: $speed');
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
    log.info('Setting speed to: $spd');
    return prefs.setInt(speedkey, spd);
  }

  Future<void> setSize(int size) {
    log.info('Setting text size to: $size');
    return prefs.setInt(sizekey, size);
  }

  int? getSize() {
    final size = prefs.containsKey(sizekey) ? prefs.getInt(sizekey) : 40;
    log.fine('Getting text size: $size');
    return size;
  }

  int? getSpeed() {
    final speed = prefs.containsKey(speedkey) ? prefs.getInt(speedkey) : 200;
    log.fine('Getting speed: $speed');
    return speed;
  }
}
