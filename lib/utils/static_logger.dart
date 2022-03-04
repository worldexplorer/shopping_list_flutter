import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/theme.dart';

final staticLoggerProvider = ChangeNotifierProvider<StaticLoggerNotifier>(
    (ref) => StaticLoggerNotifier.instance);

// ChangeNotifier requires instance =>
// 1) staticLoggerProvider or StaticLogger.append() creates an instance,
// 2) on StaticLogger.append(), I notify whoever is ref.watch()'ing
class StaticLoggerNotifier extends ChangeNotifier {
  static StaticLoggerNotifier? _instance;

  static StaticLoggerNotifier get instance {
    if (StaticLoggerNotifier._instance == null) {
      _instance = StaticLoggerNotifier();
    }
    return _instance!;
  }
}

class StaticLogger {
  static List<String> buffer = [];

  static append(String msg) {
    // final dateFormatterHms = DateFormat('Hms');
    String nowHms = dateFormatterHmsMillis.format(DateTime.now());
    var withTime = '[$nowHms] $msg';
    debugPrint(withTime);
    buffer.add(withTime);
    Future.delayed(const Duration(milliseconds: 200), () async {
      StaticLoggerNotifier.instance.notifyListeners();
    });
  }

  static void clear() {
    buffer.clear();
    StaticLoggerNotifier.instance.notifyListeners();
  }
}
