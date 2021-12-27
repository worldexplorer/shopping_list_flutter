import 'package:flutter/foundation.dart';

class StaticLogger {
  static List<String> buffer = [];
  static append(String msg) {
    final now = DateTime.now();
    final timeStamp = '${now.hour}:${now.minute}.${now.millisecond}';
    var withTime = '${timeStamp} ${msg}';
    debugPrint(withTime);
    buffer.add(withTime);
  }

  static dumpAll([String separator = '\n']) {
    return buffer.join(separator);
  }
}
