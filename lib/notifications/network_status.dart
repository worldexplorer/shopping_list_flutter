import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/my_shared_preferences.dart';
import '../utils/static_logger.dart';

const PERMANENT_ID = 0;

class NetworkStatusPermanent {
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late AndroidNotificationDetails _androidPlatformMessageChannelSpecifics;
  late NotificationDetails _platformMessageChannelSpecifics;

  NetworkStatusPermanent(this._flutterLocalNotificationsPlugin) {
    _androidPlatformMessageChannelSpecifics = const AndroidNotificationDetails(
        'networkStatus', 'Network status changed',
        channelDescription: 'Network status',
        category: 'msg',
        importance: Importance.max,
        priority: Priority.high,
        playSound: false,
        enableVibration: false,
        ongoing: true);

    _platformMessageChannelSpecifics =
        NotificationDetails(android: _androidPlatformMessageChannelSpecifics);

    Future(() async {
      enabled = await MySharedPreferences.getKeepAlive();
      StaticLogger.append('getKeepAlive=$enabled');
    });
  }

  bool _enabled = false;
  bool get enabled => _enabled;
  set enabled(bool newEnable) {
    _enabled = newEnable;

    if (!_enabled) {
      cancel();
    }
  }

  toggleEnabled() {
    enabled = !enabled;
  }

  cancel() {
    _flutterLocalNotificationsPlugin.cancel(PERMANENT_ID);
  }

  networkStatusChanged(String msg) {
    if (enabled) {
      _flutterLocalNotificationsPlugin.show(
          PERMANENT_ID, null, msg, _platformMessageChannelSpecifics);
    } else {
      cancel();
    }
  }
}
