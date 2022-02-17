import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class StaticLogger {
  static List<String> buffer = [];
  static append(String msg) {
    final now = DateTime.now();
    var formatter = DateFormat('Hms');
    String hms = formatter.format(now);
    final timeStamp = '[$hms.${now.millisecond}]';
    var withTime = '$timeStamp $msg';
    debugPrint(withTime);
    buffer.add(withTime);
  }

  static dumpAll([String separator = '\n']) {
    return buffer.join(separator);
  }

  static void clear() {
    buffer.clear();
  }
}
