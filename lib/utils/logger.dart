import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kReleaseMode, debugPrint;
import 'package:logging/logging.dart';

void setupLogging({Level level = Level.ALL}) {
  Logger.root.level = kReleaseMode ? Level.INFO : level;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    final levelName = record.level.name;
    final loggerName = record.loggerName;
    final msg = record.message;

    debugPrint('[$time] $levelName: $loggerName: $msg');

    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });
}

Logger getLogger(String name) => Logger(name);
