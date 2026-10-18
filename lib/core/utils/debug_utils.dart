import 'package:flutter/foundation.dart';

class DebugUtils {
  static void log(String message, {String tag = 'GSTSOF_DEBUG'}) {
    if (kDebugMode) {
      print('[$tag] -> $message');
    }
  }

  static void logError(String message, {Object? error, StackTrace? stackTrace, String tag = 'GSTSOF_ERROR'}) {
    if (kDebugMode) {
      print('[$tag] -> $message ${error != null ? '| Error: $error' : ''}');
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }
}
