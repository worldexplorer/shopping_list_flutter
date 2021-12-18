import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HerokuWorkaround {
  // https://pub.dev/packages/http/example
  static Future<int> fetchWebsocketPort(String wsPortJsonHost) async {
    int port = 0;
    try {
      Uri uri = Uri.http(wsPortJsonHost, '/');
      // Await the http get response, then decode the json-formatted response.
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final json = convert.jsonDecode(resp.body) as Map<String, dynamic>;
        port = json['WEBSOCKET_PORT'];

        debugPrint('HerokuWorkaround:$port replied: $json');
      } else {
        debugPrint('FAILED HerokuWorkaround:$port: ${resp.statusCode}.');
      }
    } catch (e) {
      debugPrint(
          'FAILED HerokuWorkaround:$port http.get($wsPortJsonHost): ${e.toString()}.');
    }
    return port;
  }
}
