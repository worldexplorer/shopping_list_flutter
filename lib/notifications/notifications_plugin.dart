import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

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
  String? selectedNotificationPayload;
  late BehaviorSubject<String?> selectNotificationSubject;

  NotificationsPlugin() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    selectNotificationSubject = BehaviorSubject<String?>();
  }

  initInMain() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureLocalTimeZone();

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
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }
}
