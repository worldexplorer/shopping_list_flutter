// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:mobile_number/mobile_number.dart';
// import 'package:shopping_list_flutter/utils/static_logger.dart';
// import 'device_emulator_detector.dart';

import 'env.dart';
import 'heroku_workaround.dart';

class EnvLoader {
  // https://blog.codemagic.io/flutter-ui-socket/
  static Future<Env> load([forceHeroku = false]) async {
    Env ret = forceHeroku ? PROD_HEROKU : DEV_LOCAL;

    bool isEmulator = true;
    // try {
    //   // isEmulator = await DeviceEmulatorDetector.detectEmulator();
    //   // StaticLogger.append(
    //   //     'EnvLoader:load(): deviceInfo=${DeviceEmulatorDetector.deviceInfo}');
    //
    //   final env = Platform.environment;
    //   final twoColumns = env.entries
    //       .map((mapEntry) => '${mapEntry.key}\t\t${mapEntry.value}')
    //       .join('\n');
    //
    //   StaticLogger.append(
    //     'EnvLoader:load(): Platform.environment:\n\n$twoColumns\n\n',
    //   );
    //
    //   isEmulator = DeviceEmulatorDetector.isEmulator(env);
    //   StaticLogger.append('EnvLoader:load(): isEmulator=$isEmulator');
    // } catch (e) {
    //   StaticLogger.append(
    //       'FAILED EnvLoader:load(): DeviceInfo().readDeviceData(): ${e.toString()}');
    // }

    bool isPhysicalDevice = false;
    // try {
    //   isPhysicalDevice = await platformPlus.isPhysicalDevice();
    //   StaticLogger.append(
    //       'EnvLoader:load(): isPhysicalDevice=$isPhysicalDevice');
    // } catch (e) {
    //   StaticLogger.append(
    //       'FAILED EnvLoader:load(): platformPlus.isPhysicalDevice(): ${e.toString()}');
    // }

    String mobileNumber = ret.myMobile;
    // try {
    //   mobileNumber = await fetchMobileNumber(DEV_LOCAL.myMobile);
    //   StaticLogger.append('EnvLoader:load(): mobileNumber=$mobileNumber');
    // } catch (e) {
    //   StaticLogger.append(
    //       'FAILED EnvLoader:load() to detect mobileNumber: ${e.toString()}');
    // }

    if (isPhysicalDevice || !isEmulator) {
      ret = PROD_HEROKU;
      ret.myMobile = mobileNumber;
    }

    if (ret.wsPortJsonURL != null) {
      final int port =
          await HerokuWorkaround.fetchWebsocketPort(ret.wsPortJsonURL!);
      if (port != 0) {
        ret.websocketURL += ':$port';
      }
    }

    return ret;
  }

  // https://pub.dev/packages/mobile_number/example
  // Platform messages are asynchronous, so we initialize in an async method.
  // static Future<String> fetchMobileNumber(String devNumber) async {
  //   String mobileNumber = devNumber;
  //
  //   if (!await MobileNumber.hasPhonePermission) {
  //     await MobileNumber.requestPhonePermission;
  //   }
  //
  //   List<SimCard> _simCard = <SimCard>[];
  //
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     mobileNumber = (await MobileNumber.mobileNumber)!;
  //     _simCard = (await MobileNumber.getSimCards)!;
  //   } on PlatformException catch (e) {
  //     StaticLogger.append(
  //         "Failed to get mobile number because of '${e.message}'");
  //   }
  //
  //   return mobileNumber;
  // }
}
