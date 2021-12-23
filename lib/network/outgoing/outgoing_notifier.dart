import 'package:flutter/foundation.dart';
import 'package:shopping_list_flutter/network/common/message_dto.dart';
import 'package:shopping_list_flutter/network/common/typing_dto.dart';
import 'package:shopping_list_flutter/network/incoming/incoming_notifier.dart';
import 'package:shopping_list_flutter/network/outgoing/get_messages_dto.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../connection_notifier.dart';
import '../net_log.dart';
import 'login_dto.dart';

class OutgoingNotifier extends ChangeNotifier {
  ConnectionNotifier connectionNotifier;
  IncomingNotifier incomingNotifier;

  OutgoingNotifier(this.connectionNotifier, this.incomingNotifier);

  sendLogin(String phone) {
    if (!connectionNotifier.socketConnected) {
      StaticLogger.append('sendLogin($phone): ${connectionNotifier.socketId}');
      return;
    }
    final json = LoginDto(
      phone: phone,
    ).toJson();
    connectionNotifier.socket.emit("login", json);
    StaticLogger.append('<< LOGIN [$json]');
  }

  sendTyping(bool typing) {
    if (!connectionNotifier.socketConnected) {
      // StaticLogger.append('sendTyping($typing): ${connectionNotifier.socketId}');
      return;
    }
    connectionNotifier.socket.emit(
        "typing",
        TypingDto(
          socketId: connectionNotifier.socketId,
          userName: incomingNotifier.userName,
          typing: typing,
        ).toJson());
  }

  sendMessage(String msg) {
    sendTyping(false);

    if (!connectionNotifier.socketConnected) {
      NetLog.showSnackBar(
          'sendMessage($msg): ${connectionNotifier.socketId}', 10, () => {});
      return;
    }

    final json = MessageDto(
      id: null,
      date_created: DateTime.now(),
      date_updated: DateTime.now(),
      content: msg,
      room: incomingNotifier.currentRoomId,
      user: incomingNotifier.userId,
      user_name: incomingNotifier.userName,
      purchaseId: null,
      purchase: null,
    ).toJson();
    connectionNotifier.socket.emit("newMessage", json);
    StaticLogger.append('<< NEW_MESSAGE [$json]');
  }

  sendGetMessages(int roomId, [int fromMessageId = 0]) {
    if (!connectionNotifier.socketConnected) {
      StaticLogger.append(
          'sendRoomChange($roomId): ${connectionNotifier.socketId}');
      return;
    }
    final json = GetMessagesDto(
      room: roomId,
      fromMessageId: fromMessageId,
      deviceTimezoneOffsetMinutes: 180,
    ).toJson();
    connectionNotifier.socket.emit("getMessages", json);
    StaticLogger.append('<< GET_MESSAGES [$json]');
  }
}
