class Env {
  late String envName;
  late String websocketURL;

  Env(Map<String, dynamic> jsonParsed) {
    envName = jsonParsed['name'] as String;
    websocketURL = jsonParsed['websocketURL'] as String;
  }
}
