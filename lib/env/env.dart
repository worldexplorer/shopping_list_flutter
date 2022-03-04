class Env {
  // server environment
  String envName;
  String websocketURL;
  // String? wsPortJsonURL;
  // app runtime variables
  String? myAuthToken;

  static bool forceHeroku = true;
  static Env current = forceHeroku ? PROD_HEROKU : DEV_HOME;

  Env({
    required this.envName,
    // this.wsPortJsonURL,
    required this.websocketURL,
    this.myAuthToken,
  });
}

const anonymousAuthToken = '123456';

final Env DEV_EMULATOR =
    Env(envName: 'DEV_EMULATOR', websocketURL: 'http://10.0.2.2:5000');

final Env DEV_HOME =
    Env(envName: 'DEV_HOME', websocketURL: 'http://192.168.43.105:5000');

final Env PROD_HEROKU = Env(
    envName: 'PROD_HEROKU',
    // wsPortJsonURL: 'http://shopping-list-server-typescrip.herokuapp.com',
    websocketURL: 'https://shopping-list-server-typescrip.herokuapp.com');
