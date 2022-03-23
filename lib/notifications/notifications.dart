import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/incoming/message/message_dto.dart';
import '../network/incoming/person/person_dto.dart';

class Notifications {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late List<Message> messages;

  final  Person me = const Person(
    name: 'Me_NEVER_SHOWN',
    key: '2',
    uri: 'tel:9876543210',
    // icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  );

  Notifications({required this.flutterLocalNotificationsPlugin}) {
    messages = [];
  }

  showIncomingMessage(MessageDto msg, String roomName, PersonDto? author) {
    Person coworker = Person(
      name: author != null ? author!.name : 'AUTHOR_UNKNOWN',
      key: author != null ? 'personId:${author!.id}' : 'AUTHOR_UNKNOWN',
      // uri: author != null ? author!.name : 'AUTHOR_UNKNOWN',
      // icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    );

    final message = Message(
        msg.content, DateTime.now().add(const Duration(minutes: 5)), coworker);
    messages.add(message);

    MessagingStyleInformation
    messagingStyle = MessagingStyleInformation(me,
        groupConversation: true,
        conversationTitle: roomName,
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);

    String groupKey = 'room:${msg.room}';
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('message channel id', 'message channel name',
            // sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
            playSound: true,
            channelDescription: 'message channel description',
            category: 'msg',
            styleInformation: messagingStyle,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
        0, 'message title', 'message body', platformChannelSpecifics);
  }
}
