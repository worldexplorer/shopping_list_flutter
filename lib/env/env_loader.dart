import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:mobile_number/mobile_number.dart';

import 'env.dart';
import 'heroku_workaround.dart';
import 'is_emulator.dart';

class EnvLoader {
  // https://blog.codemagic.io/flutter-ui-socket/
  static Future<Env> load([forceProd = false]) async {
    Env ret = forceProd ? PROD_HEROKU : DEV_LOCAL;

    bool isEmulator = true;
    try {
      isEmulator = await EmulatorDetector.detectEmulator();
      debugPrint('EnvLoader:load(): deviceInfo=${EmulatorDetector.deviceInfo}');
    } catch (e) {
      debugPrint(
          'FAILED EnvLoader:load(): DeviceInfo().readDeviceData(): ${e.toString()}');
    }

    bool isPhysicalDevice = false;
    try {
      isPhysicalDevice = await platformPlus.isPhysicalDevice();
      debugPrint('EnvLoader:load(): isPhysicalDevice=$isPhysicalDevice');
    } catch (e) {
      debugPrint(
          'FAILED EnvLoader:load(): platformPlus.isPhysicalDevice(): ${e.toString()}');
    }

    String mobileNumber = ret.myMobile;
    try {
      mobileNumber = await fetchMobileNumber(DEV_LOCAL.myMobile);
      debugPrint('EnvLoader:load(): mobileNumber=$mobileNumber');
    } catch (e) {
      debugPrint(
          'FAILED EnvLoader:load() to detect mobileNumber: ${e.toString()}');
    }

    if (isPhysicalDevice || !isEmulator) {
      ret = PROD_HEROKU;
      ret.myMobile = mobileNumber;
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
