class Env {
  // server environment
  String envName;
  String websocketURL;
  String? wsPortJsonURL;
  String myMobile;
  // app runtime variables
  String? myAuthToken;
  bool loggedIn = false;

  Env({
    required this.envName,
    this.wsPortJsonURL,
    required this.websocketURL,
    required this.myMobile,
    this.myAuthToken,
    this.loggedIn = false,
  });
}

final Env DEV_LOCAL = Env(
    envName: 'DEV_LOCAL',
    websocketURL: 'http://10.0.2.2:5000',
    myMobile: '+1-555-555-55-55');

final Env PROD_HEROKU = Env(
    envName: 'PROD_HEROKU',
    // wsPortJsonURL: 'http://shopping-list-server-typescrip.herokuapp.com',
    websocketURL: 'https://shopping-list-server-typescrip.herokuapp.com',
    myMobile: '+1-555-555-55-55');
