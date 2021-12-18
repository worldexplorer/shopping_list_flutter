import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:mobile_number/mobile_number.dart';

import 'heroku_workaround.dart';
import 'is_emulator.dart';

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

class EnvLoader {
  // https://blog.codemagic.io/flutter-ui-socket/
  static Future<Env> load([forceProd = true]) async {
    Env ret = forceProd ? PROD_HEROKU : DEV_LOCAL;

    try {
      bool isEmulator = await EmulatorDetector.detectEmulator();
      bool isPhysicalDevice = await platformPlus.isPhysicalDevice();
      String mobileNumber = await fetchMobileNumber(DEV_LOCAL.myMobile);

      if (isPhysicalDevice || !isEmulator) {
        ret = PROD_HEROKU;
        ret.myMobile = mobileNumber;
      }
      debugPrint('EnvLoader:load(): mobileNumber=${mobileNumber}');
    } catch (e) {
      debugPrint(
          'FAILED EnvLoader:load() to detect mobileNumber: ${e.toString()}');
    }

    if (ret.wsPortJsonHost != null) {
      final int port =
          await HerokuWorkaround.fetchWebsocketPort(ret.wsPortJsonHost!);
      if (port != 0) {
        ret.websocketURL += ':$port';
      }
    }

    return ret;
  }

  // https://pub.dev/packages/mobile_number/example
  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<String> fetchMobileNumber(String devNumber) async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
    }

    String mobileNumber = devNumber;
    List<SimCard> _simCard = <SimCard>[];

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    return mobileNumber;
  }
}
