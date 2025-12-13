import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class AppLogger {
  AppLogger._();
  
  static bool _enabled = kDebugMode;
  static LogLevel _minLevel = LogLevel.debug;
  
  static void configure({bool? enabled, LogLevel? minLevel}) {
    if (enabled != null) _enabled = enabled;
    if (minLevel != null) _minLevel = minLevel;
  }
  
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;
    if (level.index < _minLevel.index) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.toUpperCase();
    final tagPrefix = tag != null ? '[$tag] ' : '';
    
    final logMessage = '[$timestamp] [$levelName] $tagPrefix$message';
    
    switch (level) {
      case LogLevel.debug:
        debugPrint('\x1B[37m$logMessage\x1B[0m');
        break;
      case LogLevel.info:
        debugPrint('\x1B[34m$logMessage\x1B[0m');
        break;
      case LogLevel.warning:
        debugPrint('\x1B[33m$logMessage\x1B[0m');
        break;
      case LogLevel.error:
        debugPrint('\x1B[31m$logMessage\x1B[0m');
        break;
    }
    
    if (error != null) {
      debugPrint('\x1B[31mError: $error\x1B[0m');
    }
    
    if (stackTrace != null) {
      debugPrint('\x1B[31mStackTrace: $stackTrace\x1B[0m');
    }
  }
}
