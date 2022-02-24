// https://blog.logrocket.com/using-sharedpreferences-in-flutter-to-store-data-locally/
// https://dev.to/simonpham/using-sharedpreferences-in-flutter-effortlessly-3e29
// https://stackoverflow.com/questions/52831605/flutter-shared-preferences#54031842

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const MY_AUTH_TOKEN = 'shli_auth_token';

class MySharedPreferences {
  static Future<String?> getMyAuthToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(MY_AUTH_TOKEN);
    // return 'aaa';
    var storage = const FlutterSecureStorage();
    return await storage.read(key: MY_AUTH_TOKEN);
  }

  static Future<void> setMyAuthToken(String value) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(MY_AUTH_TOKEN, value);
    var storage = const FlutterSecureStorage();
    await storage.write(key: MY_AUTH_TOKEN, value: value);
  }
}

// https://carmine.dev/posts/jwtauth/
