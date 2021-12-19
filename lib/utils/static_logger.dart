import 'package:flutter/foundation.dart';

class StaticLogger {
  static List<String> buffer = [];
  static append(String msg) {
    debugPrint(msg);
    buffer.add(msg);
  }

  static dumpAll() {
    return buffer.join('\n');
  }
}
