import 'package:shopping_list_flutter/network/incoming/purchase_dto.dart';

import '../common/typing_dto.dart';
import '../connection_state.dart';
import '../incoming/incoming_state.dart';
import '../../utils/static_logger.dart';
import 'archive_messages_dto.dart';
import 'delete_messages_dto.dart';
import 'edit_message_dto.dart';
import 'login_dto.dart';
import 'new_message_dto.dart';
import 'get_messages_dto.dart';
import 'mark_message_read_dto.dart';
import 'new_purchase_dto.dart';

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

  sendMessage(String msg, int? isReplyingToMessageId) {
    if (!connectionState.socketConnected) {
      StaticLogger.append('sendMessage($msg): ${connectionState.socketId}');
      return;
    }

    sendTyping(false);

    final json = NewMessageDto(
      room: incomingState.currentRoomId,
      user: incomingState.userId,
      content: msg,
      replyto_id: isReplyingToMessageId,
      purchase: null,
    ).toJson();
    connectionState.socket.emit("newMessage", json);
    StaticLogger.append('<< NEW_MESSAGE [$json]');
  }

  sendEditMessage(int messageId, String msg) {
    if (!connectionState.socketConnected) {
      StaticLogger.append('sendEditMessage($msg): ${connectionState.socketId}');
      return;
    }

    sendTyping(false);

    final json = EditMessageDto(
      id: messageId,
      content: msg,
      purchase: null,
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
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendMarkMessagesRead($messageIds): ${connectionState.socketId}');
      return;
    }

    final json = MarkMessagesReadDto(
      messageIds: messageIds,
      user: userId,
    ).toJson();
    connectionState.socket.emit("markMessagesRead", json);
    StaticLogger.append('<< MARK_MESSAGE_READ [$json]');
  }

  sendArchiveMessages(List<int> messageIds, int userId,
      [bool archived = true]) {
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendArchiveMessages($messageIds): ${connectionState.socketId}');
      return;
    }

    final json = ArchiveMessagesDto(
      messageIds: messageIds,
      archived: archived,
      user: userId,
    ).toJson();
    connectionState.socket.emit("archiveMessages", json);
    StaticLogger.append('<< ARCHIVE_MESSAGES [$json]');
  }

  sendDeleteMessages(List<int> messageIds, int userId) {
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendDeleteMessages($messageIds): ${connectionState.socketId}');
      return;
    }

    final json = DeleteMessagesDto(
      messageIds: messageIds,
      user: userId,
    ).toJson();
    connectionState.socket.emit("deleteMessages", json);
    StaticLogger.append('<< DELETE_MESSAGES [$json]');
  }

  sendGetMessages(int roomId, [int fromMessageId = 0, bool archived = false]) {
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendRoomChange($roomId): ${connectionState.socketId}');
      return;
    }
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
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendNewPurchase(${purchase.room}): ${connectionState.socketId}');
      return;
    }
    final json = NewPurchaseDto(
      name: purchase.name,
      room: purchase.room,
      message: purchase.message,
      show_pgroup: purchase.show_pgroup,
      show_price: purchase.show_price,
      show_qnty: purchase.show_qnty,
      show_weight: purchase.show_weight,
      copiedfrom_id: purchase.copiedfrom_id,
      person_created: purchase.person_created,
      person_created_name: purchase.person_created_name,
      persons_can_edit: purchase.persons_can_edit,
      purchased: purchase.purchased,
      person_purchased_name: purchase.person_purchased_name,
      price_total: purchase.price_total,
      weight_total: purchase.weight_total,
      purItems: purchase.purItems,
    ).toJson();
    connectionState.socket.emit("newPurchase", json);
    StaticLogger.append('<< NEW_PURCHASE [$json]');
  }

  void sendEditPurchase(PurchaseDto purchase) {
    if (!connectionState.socketConnected) {
      StaticLogger.append(
          'sendEditPurchase${purchase.room}): ${connectionState.socketId}');
      return;
    }
    final json = purchase.toJson();
    connectionState.socket.emit("editPurchase", json);
    StaticLogger.append('<< EDIT_PURCHASE [$json]');
  }
}
