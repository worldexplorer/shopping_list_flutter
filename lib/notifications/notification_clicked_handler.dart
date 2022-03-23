import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'notifications_plugin.dart';
import 'received_notification.dart';

// https://pub.dev/packages/flutter_local_notifications/example
class NotificationClickedHandler {
  late BuildContext context;
  late String currentRoomPath;
  late BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject;

  NotificationClickedHandler(this.context, this.currentRoomPath) {
    didReceiveLocalNotificationSubject =
        BehaviorSubject<ReceivedNotification>();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) =>
                //         SecondPage(receivedNotification.payload),
                //   ),
                // );
                Navigator.pushNamed(context, '/secondPage',
                    arguments: receivedNotification.payload);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    NotificationsPlugin.instance.selectNotificationSubject.stream
        .listen((String? payload) async {
      // await Navigator.pushNamed(context, '/secondPage');
      if (payload != null) {
        final int? roomId = int.tryParse(payload!);
        if (roomId != null) {
          await Navigator.pushNamed(context, currentRoomPath,
              arguments: roomId!);
        }
      }
    });
  }

  // @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    // super.dispose();
  }
}
