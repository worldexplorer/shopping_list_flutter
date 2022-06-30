// https://blog.logrocket.com/using-sharedpreferences-in-flutter-to-store-data-locally/
// https://dev.to/simonpham/using-sharedpreferences-in-flutter-effortlessly-3e29
// https://stackoverflow.com/questions/52831605/flutter-shared-preferences#54031842

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

const MY_AUTH_TOKEN = 'shli_auth_token';
const KEEP_ALIVE = 'shli_keep_alive';

class MySharedPreferences {
  static Future<String?> getMyAuthToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(MY_AUTH_TOKEN);
    // return 'aaa';
    try {
      WidgetsFlutterBinding.ensureInitialized();
      var storage = const FlutterSecureStorage();
      return await storage.read(key: MY_AUTH_TOKEN);
    } catch (e) {
      String msig = 'FlutterSecureStorage().read(key: ${MY_AUTH_TOKEN})';
      StaticLogger.append('$msig ${e.toString}');
    }
    return null;
  }

  static Future<void> setMyAuthToken(String value) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(MY_AUTH_TOKEN, value);
    try {
      var storage = const FlutterSecureStorage();
      await storage.write(key: MY_AUTH_TOKEN, value: value);
    } catch (e) {
      String msig =
          'FlutterSecureStorage().write(key: ${MY_AUTH_TOKEN}, value: ${value})';
      StaticLogger.append('$msig ${e.toString}');
    }
  }

  static Future<bool> getKeepAlive() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      var storage = const FlutterSecureStorage();
      var asString = await storage.read(key: KEEP_ALIVE);
      return asString != 'NO'; // true if not present / first time run
    } catch (e) {
      String msig = 'FlutterSecureStorage().read(key: ${KEEP_ALIVE})';
      StaticLogger.append('$msig ${e.toString}');
    }
    return false;
  }

  static Future<void> setKeepAlive(bool value) async {
    var asString = value ? 'YES' : 'NO';
    try {
      var storage = const FlutterSecureStorage();
      await storage.write(key: KEEP_ALIVE, value: asString);
    } catch (e) {
      String msig =
          'FlutterSecureStorage().write(key: ${KEEP_ALIVE}, value: ${asString})';
      StaticLogger.append('$msig ${e.toString}');
    }
  }
}

// https://carmine.dev/posts/jwtauth/
