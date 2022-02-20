// import 'package:shared_preferences/shared_preferences.dart';

const MY_AUTH_TOKEN = 'shli_auth_token';

class MySharedPreferences {
  static Future<String?> getMyAuthToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(MY_AUTH_TOKEN);
    return 'aaa';
  }

  static Future<void> setMyAuthToken(String value) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(MY_AUTH_TOKEN, value);
  }
}
