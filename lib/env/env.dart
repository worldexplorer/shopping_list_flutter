class Env {
  String envName;
  String websocketURL;
  String? wsPortJsonHost;
  String myMobile;

  Env(
      {required this.envName,
      this.wsPortJsonHost,
      required this.websocketURL,
      required this.myMobile});
}

final Env DEV_LOCAL = Env(
    envName: "DEV_LOCAL",
    websocketURL: "http://10.0.2.2:5000",
    myMobile: "+1-555-555-55-55");

final Env PROD_HEROKU = Env(
    envName: "PROD_HEROKU",
    // wsPortJsonHost: "shopping-list-server-typescrip.herokuapp.com",
    websocketURL: "http://shopping-list-server-typescrip.herokuapp.com:80",
    myMobile: "+1-555-555-55-55");
