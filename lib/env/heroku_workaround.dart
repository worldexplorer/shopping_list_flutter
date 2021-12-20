import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shopping_list_flutter/utils/static_logger.dart';

class HerokuWorkaround {
  // https://pub.dev/packages/http/example
  static Future<int> fetchWebsocketPort(String wsPortJsonUrl) async {
    int port = 0;
    try {
      // http://shopping-list-server-typescrip.herokuapp.com
      Uri uri = Uri.parse(wsPortJsonUrl);
      // Await the http get response, then decode the json-formatted response.
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final json = convert.jsonDecode(resp.body) as Map<String, dynamic>;
        port = json['WEBSOCKET_PORT']; // json = {"WEBSOCKET_PORT":30521}

        StaticLogger.append('HerokuWorkaround:$port replied: $json');
      } else {
        StaticLogger.append(
            'FAILED HerokuWorkaround:$port: ${resp.statusCode}.');
      }
    } catch (e) {
      StaticLogger.append(
          'FAILED HerokuWorkaround:$port http.get($wsPortJsonUrl): ${e.toString()}.');
    }
    return port;
  }
}
