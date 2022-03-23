import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notifications_plugin.dart';

// https://pub.dev/packages/flutter_local_notifications/example
class NotificationsTest {
  Future<void> showMessagingNotification() async {
    // use a platform channel to resolve an Android drawable resource to a URI.
    // This is NOT part of the notifications plugin. Calls made over this
    /// channel is handled by the app
    // final String? imageUri =
    //     await platform.invokeMethod('drawableToUri', 'food');

    /// First two person objects will use icons that part of the Android app's
    /// drawable resources
    const Person me = Person(
      name: 'Me',
      key: '1',
      uri: 'tel:1234567890',
      // icon: DrawableResourceAndroidIcon('me'),
    );

    const Person coworker = Person(
      name: 'Coworker',
      key: '2',
      uri: 'tel:9876543210',
      // icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    );

    // download the icon that would be use for the lunch bot person
    // final String largeIconPath = await _downloadAndSaveFile(
    //     'https://via.placeholder.com/48x48', 'largeIcon');

    // this person object will use an icon that was downloaded
    const Person lunchBot = Person(
      name: 'Lunch bot',
      key: 'bot',
      bot: true,
      // icon: BitmapFilePathAndroidIcon(largeIconPath),
    );

    const Person chef = Person(
      name: 'Master Chef',
      key: '3',
      uri: 'tel:111222333444',
      // icon: ByteArrayAndroidIcon.fromBase64String(
      //     await _base64encodedImage('https://placekitten.com/48/48'))
    );

    final List<Message> messages = <Message>[
      Message('Hi', DateTime.now(), null),
      Message("What's up?", DateTime.now().add(const Duration(minutes: 5)),
          coworker),
      // Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
      //     dataMimeType: 'image/png', dataUri: imageUri),
      Message('What kind of food would you prefer?',
          DateTime.now().add(const Duration(minutes: 10)), lunchBot),
      Message('You do not have time eat! Keep working!',
          DateTime.now().add(const Duration(minutes: 11)), chef),
    ];
    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
        me,
        groupConversation: true,
        conversationTitle: 'Team lunch',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('message channel id', 'message channel name',
            // sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
            playSound: true,
            channelDescription: 'message channel description',
            category: 'msg',
            styleInformation: messagingStyle);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await NotificationsPlugin.instance.flutterLocalNotificationsPlugin
        .show(0, 'message title', 'message body', platformChannelSpecifics);

    // wait 10 seconds and add another message to simulate another response
    await Future<void>.delayed(const Duration(seconds: 10), () async {
      messages.add(Message("I'm so sorry!!! But I really like thai food ...",
          DateTime.now().add(const Duration(minutes: 11)), null));
      await NotificationsPlugin.instance.flutterLocalNotificationsPlugin
          .show(0, 'message title', 'message body', platformChannelSpecifics);
    });
  }

  Future<void> showGroupedNotifications() async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await NotificationsPlugin.instance.flutterLocalNotificationsPlugin.show(
        1,
        'Alex Faarborg',
        'You will not believe...',
        firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics);
    await NotificationsPlugin.instance.flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '2 messages',
        summaryText: 'janedoe@example.com');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(groupChannelId, groupChannelName,
            channelDescription: groupChannelDescription,
            styleInformation: inboxStyleInformation,
            groupKey: groupKey,
            setAsGroupSummary: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await NotificationsPlugin.instance.flutterLocalNotificationsPlugin
        .show(3, 'Attention', 'Two messages', platformChannelSpecifics);
  }
}
