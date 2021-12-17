import 'dart:convert';
import 'package:flutter/services.dart';
import 'env.dart';

class EnvLoader {
  static Env ret = Env({});

  static Future<Env> load() async {
    try {
      final jsonDeserialized =
          await rootBundle.loadString('env/app_config_heroku.json');
      Map<String, dynamic> jsonParsed =
          json.decode(jsonDeserialized) as Map<String, dynamic>;
      ret = Env(jsonParsed);
    } catch (e) {
      print(e.toString());
    }

    return ret;
  }
}
