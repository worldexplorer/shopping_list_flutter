import '../common/typing_dto.dart';
import '../connection_notifier.dart';
import '../incoming/incoming_notifier.dart';
import '../../utils/static_logger.dart';
import '../net_log.dart';
import 'edit_message_dto.dart';
import 'login_dto.dart';
import 'new_message_dto.dart';
import './get_messages_dto.dart';

class Outgoing {
  ConnectionNotifier connectionNotifier;
  IncomingNotifier incomingNotifier;

  Outgoing(this.connectionNotifier, this.incomingNotifier);

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

    final json = NewMessageDto(
      content: msg,
      room: incomingNotifier.currentRoomId,
      user: incomingNotifier.userId,
      purchase: null,
    ).toJson();
    connectionNotifier.socket.emit("newMessage", json);
    StaticLogger.append('<< NEW_MESSAGE [$json]');
  }

  sendEditMessage(int id, String msg) {
    sendTyping(false);

    if (!connectionNotifier.socketConnected) {
      NetLog.showSnackBar(
          'sendEditMessage($msg): ${connectionNotifier.socketId}',
          10,
          () => {});
      return;
    }

    final json = EditMessageDto(
      id: id,
      content: msg,
      purchase: null,
    ).toJson();
    connectionNotifier.socket.emit("editMessage", json);
    StaticLogger.append('<< EDIT_MESSAGE [$json]');
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
