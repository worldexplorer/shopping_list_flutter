// https://stackoverflow.com/questions/2799097/how-can-i-detect-when-an-android-application-is-running-in-the-emulator

import 'package:shopping_list_flutter/env/device_info.dart';

class EmulatorDetector {
  static late DeviceInfo deviceInfo;

  static Future<bool> detectEmulator() async {
    deviceInfo = DeviceInfo();
    await deviceInfo.readDeviceData();
    return isEmulator(deviceInfo.deviceData);
  }

  static bool isEmulator(Map<String, dynamic> deviceData) {
    int rating = 0;

    final productAndroidOrWeb = deviceData['product'];
    if (productAndroidOrWeb &&
        ["sdk", "google_sdk", "sdk_x86", "vbox86p"]
            .contains(productAndroidOrWeb)) {
      rating++;
    }

    final manufacturerAndroid = deviceData['manufacturer'];
    if (manufacturerAndroid &&
        ["unknown", "Genymotion"].contains(manufacturerAndroid)) {
      rating++;
    }

    final brandAndroid = deviceData['brand'];
    if (brandAndroid && ["generic", "generic_x86"].contains(brandAndroid)) {
      rating++;
    }

    final device = deviceData['device'];
    if (device && ["generic", "generic_x86", "vbox86p"].contains(device)) {
      rating++;
    }

    final modelAndroidIosMac = deviceData['model'];
    if (modelAndroidIosMac &&
        ["sdk", "google_sdk", "Android SDK built for x86"]
            .contains(modelAndroidIosMac)) {
      rating++;
    }

    final hardwareAndroid = deviceData['hardware'];
    if (hardwareAndroid && ["goldfish", "vbox86p"].contains(hardwareAndroid)) {
      rating++;
    }

    final fingerprintAndroid = deviceData['fingerprint'];
    if (fingerprintAndroid &&
        [
          "generic/sdk/generic",
          "generic_x86/sdk_x86/generic_x86",
          "generic/google_sdk/generic",
          "generic/vbox86p/vbox86p"
        ].contains(fingerprintAndroid)) {
      rating++;
    }

    return rating > 4;
  }
}
