import 'package:flutter/foundation.dart';
import 'package:shopping_list_flutter/utils/theme.dart';

class StaticLogger {
  static List<String> buffer = [];
  static append(String msg) {
    // final dateFormatterHms = DateFormat('Hms');
    String nowHms = dateFormatterHmsMillis.format(DateTime.now());
    var withTime = '[$nowHms] $msg';
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
