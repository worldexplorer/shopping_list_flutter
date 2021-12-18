import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_plus/platform_plus.dart';
// import 'package:shopping_list_flutter/network/net_log.dart';
import 'package:mobile_number/mobile_number.dart';

import 'is_emulator.dart';

class Env {
  String envName;
  String websocketURL;
  String phone;

  Env({required this.envName, required this.websocketURL, required this.phone});
}

final Env DEV_ENV = Env(
    envName: "DEV_LOCAL",
    websocketURL: "http://10.0.2.2:5000",
    phone: "+1-555-555-55-55");

class EnvLoader {
  // https://blog.codemagic.io/flutter-ui-socket/
  static Future<Env> load() async {
    var ret = DEV_ENV;

    try {
      bool isEmulator = await EmulatorDetector.detectEmulator();
      bool isPhysicalDevice = await platformPlus.isPhysicalDevice();
      String mobileNumber = await fetchMobileNumber(DEV_ENV.phone);

      if (isPhysicalDevice || !isEmulator) {
        ret = Env(
            envName: "PROD_HEROKU",
            websocketURL:
                "http://shopping-list-server-typescrip.herokuapp.com:80",
            phone: mobileNumber);
      }
    } catch (e) {
      debugPrint(e.toString());
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
