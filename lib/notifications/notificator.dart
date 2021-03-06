import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/incoming/message/message_dto.dart';
import '../network/incoming/purchase/pur_item_filled_dto.dart';
import '../network/incoming/room/room_member_dto.dart';

class Notificator {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late List<Message> messages;

  final Person me = const Person(
    name: 'Me_NEVER_SHOWN',
    key: '2',
    uri: 'tel:9876543210',
    // icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  );

  Notificator({required this.flutterLocalNotificationsPlugin}) {
    messages = [];
  }

  showIncomingMessage(MessageDto msg, String roomName, RoomMemberDto? author) {
    Person coworker = Person(
      name: author != null ? author.person_name : 'AUTHOR_UNKNOWN',
      key: author != null ? 'personId:${author.person}' : 'AUTHOR_UNKNOWN',
      // uri: author != null ? author!.name : 'AUTHOR_UNKNOWN',
      // icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    );

    final message = Message(
        msg.content, DateTime.now().add(const Duration(minutes: 5)), coworker);
    messages.add(message);

    MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
        groupConversation: true,
        conversationTitle: roomName,
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);

    String groupKey = 'room:${msg.room}';
    final AndroidNotificationDetails androidPlatformMessageChannelSpecifics =
        AndroidNotificationDetails(
            'messagesAddedEdited', 'Messages added/edited',
            sound:
                const RawResourceAndroidNotificationSound('slow_spring_board'),
            playSound: true,
            channelDescription: 'Room messages added/edited',
            category: 'msg',
            styleInformation: messagingStyle,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);

    final NotificationDetails platformMessageChannelSpecifics =
        NotificationDetails(android: androidPlatformMessageChannelSpecifics);

    String payload = msg.room.toString();
    flutterLocalNotificationsPlugin.show(
        0, 'message title', 'message body', platformMessageChannelSpecifics,
        payload: payload);
  }

  showPurItemFilled(
      PurItemFilledDto purItemFilled, String roomName, RoomMemberDto? author) {
    // TODO
  }
}
