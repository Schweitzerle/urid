import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class URIDLogger {
  static final URIDLogger _instance = URIDLogger._internal();
  late final Logger _logger;

  URIDLogger._internal() {
    _logger = Logger();
    Logger.level = Level.error;
    if (kDebugMode) {
      Logger.level = Level.debug;
    }
  }

  factory URIDLogger() {
    return _instance;
  }

  void setLevel(Level level) {
    Logger.level = level;
  }

  void verbose(msg) {
    _logger.v(msg);
  }

  void debug(msg) {
    _logger.d(msg);
  }

  void info(msg) {
    _logger.i(msg);
  }

  void warning(msg) {
    _logger.w(msg);
  }

  void error(msg) {
    _logger.e(msg);
  }

  void wtf(msg) {
    _logger.wtf(msg);
  }
}
