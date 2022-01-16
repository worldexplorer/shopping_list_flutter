import '../common/typing_dto.dart';
import '../connection_state.dart';
import '../incoming/incoming_state.dart';
import '../incoming/purchase_dto.dart';
import '../outgoing/new_purchase_dto.dart';
import '../../utils/static_logger.dart';
import 'archive_messages_dto.dart';
import 'delete_messages_dto.dart';
import 'edit_message_dto.dart';
import 'edit_purchase_dto.dart';
import 'login_dto.dart';
import 'new_message_dto.dart';
import 'get_messages_dto.dart';
import 'mark_message_read_dto.dart';
import 'new_purchase_dto.dart';
import 'purchase_filled_dto.dart';

class OutgoingHandlers {
  ConnectionState connectionState;
  IncomingState incomingState;

  OutgoingHandlers(this.connectionState, this.incomingState);

  bool isConnected(String msig) {
    if (connectionState.socketConnected) return true;

    final msg = '$msig: ${connectionState.socketId}';
    StaticLogger.append(msg);
    incomingState.serverError = msg;
    return false;
  }

  sendLogin(String phone) {
    final msig = 'sendLogin($phone)';
    if (!isConnected(msig)) return;

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

  sendMessage(String msg, int? isReplyingToMessageId) {
    final msig = 'sendMessage($msg)';
    if (!isConnected(msig)) return;

    if (!connectionState.socketConnected) {
      StaticLogger.append(': ${connectionState.socketId}');
      return;
    }

    sendTyping(false);

    final json = NewMessageDto(
      room: incomingState.currentRoomId,
      //user: incomingState.userId,
      content: msg,
      replyto_id: isReplyingToMessageId,
    ).toJson();
    connectionState.socket.emit("newMessage", json);
    StaticLogger.append('<< NEW_MESSAGE [$json]');
  }

  sendEditMessage(int messageId, String msg) {
    final msig = 'sendEditMessage($msg)';
    if (!isConnected(msig)) return;

    sendTyping(false);

    final json = EditMessageDto(
      id: messageId,
      room: incomingState.currentRoomId,
      content: msg,
    ).toJson();
    connectionState.socket.emit("editMessage", json);
    StaticLogger.append('<< EDIT_MESSAGE [$json]');
  }

  sendMarkMessagesRead() {
    if (incomingState.messagesUnreadById.isEmpty) {
      return;
    }

    final unreadMsgIds = incomingState.getOnlyUnreadMessages();
    if (unreadMsgIds.isEmpty) {
      StaticLogger.append(
          '-- MARK_MESSAGE_READ all messages already marked READ:'
          ' unreadMsgIds[0] while messagesUnreadById[${incomingState.messagesUnreadById.length}]'
          ' for userId[${incomingState.userId}]');
      return;
    }

    _sendMarkMessagesRead(unreadMsgIds, incomingState.userId);
  }

  _sendMarkMessagesRead(List<int> messageIds, int userId) {
    final msig = 'sendMarkMessagesRead($messageIds)';
    if (!isConnected(msig)) return;

    final json = MarkMessagesReadDto(
      messageIds: messageIds,
      user: userId,
    ).toJson();
    connectionState.socket.emit("markMessagesRead", json);
    StaticLogger.append('<< MARK_MESSAGE_READ [$json]');
  }

  sendArchiveMessages(List<int> messageIds, int userId,
      [bool archived = true]) {
    final msig = 'sendArchiveMessages($messageIds)';
    if (!isConnected(msig)) return;

    final json = ArchiveMessagesDto(
      messageIds: messageIds,
      archived: archived,
      user: userId,
    ).toJson();
    connectionState.socket.emit("archiveMessages", json);
    StaticLogger.append('<< ARCHIVE_MESSAGES [$json]');
  }

  sendDeleteMessages(List<int> messageIds, int userId) {
    final msig = 'sendDeleteMessages($messageIds)';
    if (!isConnected(msig)) return;

    final json = DeleteMessagesDto(
      messageIds: messageIds,
      user: userId,
    ).toJson();
    connectionState.socket.emit("deleteMessages", json);
    StaticLogger.append('<< DELETE_MESSAGES [$json]');
  }

  sendGetMessages(int roomId, [int fromMessageId = 0, bool archived = false]) {
    final msig = 'sendRoomChange($roomId)';
    if (!isConnected(msig)) return;

    final json = GetMessagesDto(
      room: roomId,
      fromMessageId: fromMessageId,
      archived: archived,
      deviceTimezoneOffsetMinutes: 180,
    ).toJson();
    connectionState.socket.emit("getMessages", json);
    StaticLogger.append('<< GET_MESSAGES [$json]');
  }

  void sendNewPurchase(PurchaseDto purchase, isReplyingToMessageId) {
    final msig = 'sendNewPurchase($purchase.room)';
    if (!isConnected(msig)) return;

    final json = NewPurchaseDto.fromPurchaseDto(purchase).toJson();
    connectionState.socket.emit("newPurchase", json);
    StaticLogger.append('<< NEW_PURCHASE [$json]');
  }

  void sendEditPurchase(PurchaseDto purchase) {
    final msig = 'sendEditPurchase($purchase.room)';
    if (!isConnected(msig)) return;

    final json = EditPurchaseDto.fromPurchaseDto(purchase).toJson();
    connectionState.socket.emit("editPurchase", json);
    StaticLogger.append('<< EDIT_PURCHASE [$json]');
  }

  void sendFillPurchase(PurchaseDto purchase) {
    final String ident =
        'id[${purchase.id}]:room[${purchase.room}]:message[${purchase.message}]';
    final msig = 'sendFillPurchase($purchase.room)';
    if (!isConnected(msig)) return;

    final purchaseFilled = PurchaseFilledDto.fromPurchaseDto(purchase);
    final json = purchaseFilled.toJson();
    connectionState.socket.emit("fillPurchase", json);
    StaticLogger.append('<< FILL_PURCHASE [$json]');
  }
}
