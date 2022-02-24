class Env {
  // server environment
  String envName;
  String websocketURL;
  String? wsPortJsonURL;
  // app runtime variables
  String? myMobile;
  String? myAuthToken;
  bool loggedIn = false;

  Env({
    required this.envName,
    this.wsPortJsonURL,
    required this.websocketURL,
    this.myMobile,
    this.myAuthToken,
    this.loggedIn = false,
  });
}

const anonymousAuthToken = '123456';

final Env DEV_LOCAL =
    Env(envName: 'DEV_LOCAL', websocketURL: 'http://10.0.2.2:5000');

final Env PROD_HEROKU = Env(
    envName: 'PROD_HEROKU',
    // wsPortJsonURL: 'http://shopping-list-server-typescrip.herokuapp.com',
    websocketURL: 'https://shopping-list-server-typescrip.herokuapp.com');
