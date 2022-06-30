// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';

import 'network_status.dart';
import 'notificator.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

// https://pub.dev/packages/flutter_local_notifications/example
class NotificationsPlugin {
  static NotificationsPlugin? _instance;

  static NotificationsPlugin get instance {
    if (NotificationsPlugin._instance == null) {
      _instance = NotificationsPlugin();
      // await _instance.initInMain();
    }
    return _instance!;
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // String? selectedNotificationPayload;
  late BehaviorSubject<String?> selectNotificationSubject;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  late Notificator notificator;
  late NetworkStatusPermanent permanent;

  NotificationsPlugin() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    selectNotificationSubject = BehaviorSubject<String?>();
    notificator = Notificator(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
    permanent = NetworkStatusPermanent(flutterLocalNotificationsPlugin);
  }

  initInMain() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      // selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });

    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload = notificationAppLaunchDetails!.payload;
      // selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    }
  }

  void disposeInWidget() {
    NotificationsPlugin.instance.selectNotificationSubject.close();
  }

  // Future<void> _configureLocalTimeZone() async {
  //   if (kIsWeb || Platform.isLinux) {
  //     return;
  //   }
  //   tz.initializeTimeZones();
  //   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  //   // tz.setLocalLocation(tz.getLocation(timeZoneName!));
  // }
}
