import '../common/typing_dto.dart';
import '../connection_state.dart';
import '../incoming/incoming_state.dart';
import '../../utils/static_logger.dart';
import 'edit_message_dto.dart';
import 'login_dto.dart';
import 'new_message_dto.dart';
import './get_messages_dto.dart';
import './mark_message_read_dto.dart';

class OutgoingHandlers {
  ConnectionState connectionState;
  IncomingState incomingState;

  OutgoingHandlers(this.connectionState, this.incomingState);

  sendLogin(String phone) {
    if (!connectionState.socketConnected) {
      StaticLogger.append('sendLogin($phone): ${connectionState.socketId}');
      return;
    }
    final json = LoginDto(
      phone: phone,
    ).toJson();
    connectionState.socket.emit("login", json);
    StaticLogger.append('<< LOGIN [$json]');
  }

  sendTyping(bool typing) {
    if (!connectionState.socketConnected) {
      // StaticLogger.append('sendTyping($typing): ${connectionNotifier.socketId}');
      return;
    }
    connectionState.socket.emit(
        "typing",
        TypingDto(
          socketId: connectionState.socketId,
          userName: incomingState.userName,
          typing: typing,
        ).toJson());
  }

  sendMessage(String msg) {
    sendTyping(false);

    if (!connectionState.socketConnected) {
      StaticLogger.append('sendMessage($msg): ${connectionState.socketId}');
      return;
    }

    final json = NewMessageDto(
      content: msg,
      room: incomingState.currentRoomId,
      user: incomingState.userId,
      purchase: null,
    ).toJson();
    connectionState.socket.emit("newMessage", json);
    StaticLogger.append('<< NEW_MESSAGE [$json]');
  }

  sendEditMessage(int messageId, String msg) {
    sendTyping(false);

    if (!connectionState.socketConnected) {
      StaticLogger.append('sendEditMessage($msg): ${connectionState.socketId}');
      return;
    }

    final json = EditMessageDto(
      id: messageId,
      content: msg,
      purchase: null,
    ).toJson();
    connectionState.socket.emit("editMessage", json);
    StaticLogger.append('<< EDIT_MESSAGE [$json]');
  }

  sendMarkMessageRead(int messageId, int userId) {
    sendTyping(false);

    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendEditMessage($messageId): ${connectionState.socketId}');
      return;
    }

    final json = MarkMessageReadDto(
      message: messageId,
      user: userId,
    ).toJson();
    connectionState.socket.emit("markMessageRead", json);
    StaticLogger.append('<< MARK_MESSAGE_READ [$json]');
  }

  sendGetMessages(int roomId, [int fromMessageId = 0]) {
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendRoomChange($roomId): ${connectionState.socketId}');
      return;
    }
    final json = GetMessagesDto(
      room: roomId,
      fromMessageId: fromMessageId,
      deviceTimezoneOffsetMinutes: 180,
    ).toJson();
    connectionState.socket.emit("getMessages", json);
    StaticLogger.append('<< GET_MESSAGES [$json]');
  }
}
