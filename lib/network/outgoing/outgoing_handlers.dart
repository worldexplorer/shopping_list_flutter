import '../../utils/static_logger.dart';
import '../common/typing_dto.dart';
import '../connection_state.dart';
import '../incoming/incoming_state.dart';
import '../incoming/purchase/pur_item_dto.dart';
import '../incoming/purchase/purchase_dto.dart';
import 'message/archive_messages_dto.dart';
import 'message/delete_messages_dto.dart';
import 'message/edit_message_dto.dart';
import 'message/get_messages_dto.dart';
import 'message/mark_message_read_dto.dart';
import 'message/new_message_dto.dart';
import 'person/login_dto.dart';
import 'person/my_name_dto.dart';
import 'person/register_confirm_dto.dart';
import 'person/register_dto.dart';
import 'purchase/edit_purchase_dto.dart';
import 'purchase/new_purchase_dto.dart';
import 'purchase/pur_item_fill_dto.dart';
import 'purchase/purchase_fill_dto.dart';
import 'room/edit_room_members_dto.dart';
import 'room/find_persons_dto.dart';
import 'room/new_room_dto.dart';
import 'room/rename_room_dto.dart';
import 'room/room_member_dto.dart';

class OutgoingHandlers {
  ConnectionState connectionState;
  IncomingState incomingState;

  OutgoingHandlers(this.connectionState, this.incomingState);

  bool isConnected(String invoker) {
    if (connectionState.socketConnected) return true;

    final msg = '$invoker: ${connectionState.socketId}';
    StaticLogger.append(msg);
    incomingState.serverError = msg;
    return false;
  }

  sendRegister(String email, String phone) {
    final msig = 'sendRegister($email, $phone)';
    if (!isConnected(msig)) return;

    final json = RegisterDto(
      email: email,
      phone: phone,
    ).toJson();
    connectionState.socket.emit("register", json);
    StaticLogger.append('<< REGISTER [$json]');
  }

  sendRegisterConfirm(String email, String phone, int codeFromEmail) {
    final msig = 'sendRegisterConfirm($email, $phone)';
    if (!isConnected(msig)) return;

    final json = RegisterConfirmDto(
      email: email,
      phone: phone,
      code: codeFromEmail,
    ).toJson();
    connectionState.socket.emit("registerConfirm", json);
    StaticLogger.append('<< REGISTER_CONFIRM [$json]');
  }

  sendLogin(String auth, String invoker) {
    final msig = 'sendLogin($auth)';
    if (!isConnected(msig)) return;

    final json = LoginDto(
      auth: auth,
    ).toJson();

    if (incomingState.waitingForLoginResponse) {
      StaticLogger.append(
          '-- LOGIN [$json] ($invoker/already waitingForLoginResponse)');
      return;
    }

    incomingState.waitingForLoginResponse = true;
    connectionState.socket.emit("login", json);
    StaticLogger.append('<< LOGIN [$json] ($invoker)');
  }

  sendMyName(int personId, String auth, String myName, String invoker) {
    final msig = 'sendMyName($personId:$auth:$myName)';
    if (!isConnected(msig)) return;

    final json = MyNameDto(
      id: personId,
      auth: auth,
      name: myName,
    ).toJson();

    connectionState.socket.emit("myName", json);
    StaticLogger.append('<< MY_NAME [$json] ($invoker)');
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
          userName: incomingState.personName,
          typing: typing,
        ).toJson());
  }

  sendMessage(String msg, int? isReplyingToMessageId) {
    final msig = 'sendMessage($msg)';
    if (!isConnected(msig)) return;

    sendTyping(false);

    final json = NewMessageDto(
      room: incomingState.rooms.currentRoomId,
      //person: incomingState.userId,
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
      room: incomingState.rooms.currentRoomId,
      content: msg,
    ).toJson();
    connectionState.socket.emit("editMessage", json);
    StaticLogger.append('<< EDIT_MESSAGE [$json]');
  }

  sendMarkMessagesRead() {
    final messagesDtoUnreadById =
        incomingState.rooms.currentRoomMessages.messagesDtoUnreadById;
    if (messagesDtoUnreadById.isEmpty) {
      return;
    }

    final unreadMsgIds =
        incomingState.rooms.currentRoomMessages.getOnlyUnreadMessages();
    if (unreadMsgIds.isEmpty) {
      StaticLogger.append(
          '-- MARK_MESSAGE_READ all messages already marked READ:'
          ' unreadMsgIds[0] while messagesUnreadById[${messagesDtoUnreadById.length}]'
          ' for userId[${incomingState.personId}]');
      return;
    }

    _sendMarkMessagesRead(unreadMsgIds, incomingState.personId);
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

    final purchaseFill = PurchaseFillDto.fromPurchaseDto(purchase);
    final json = purchaseFill.toJson();
    connectionState.socket.emit("fillPurchase", json);
    StaticLogger.append('<< FILL_PURCHASE [$json]');
  }

  void sendFillPurItem(PurItemDto purItem, PurchaseDto purchase) {
    final String ident =
        'purItem.id[${purItem.id}]:purchase[${purchase.id}]:room[${purchase.room}]:message[${purchase.message}]';
    final msig = 'sendFillPurItem($purchase.room)';
    if (!isConnected(msig)) return;

    final purItemFilled = PurItemFillDto.fromPurItem(purItem, purchase);
    final json = purItemFilled.toJson();
    connectionState.socket.emit("fillPurItem", json);
    StaticLogger.append('<< FILL_PURITEM [$json]');
  }

  void sendNewRoom(String name, List<int> userIds) {
    final msig = 'sendNewRoom($name)';
    if (!isConnected(msig)) return;

    final json = NewRoomDto(
      name: name,
      userIds: userIds,
    ).toJson();
    connectionState.socket.emit("newRoom", json);
    StaticLogger.append('<< NEW_ROOM [$json]');
  }

  void sendRenameRoom(int roomId, String newName) {
    final msig = 'sendRenameRoom($roomId, $newName)';
    if (!isConnected(msig)) return;

    final json = RenameRoomDto(
      roomId: roomId,
      newName: newName,
    ).toJson();
    connectionState.socket.emit("renameRoom", json);
    StaticLogger.append('<< RENAME_ROOM [$json]');
  }

  void sendEditRoomMembers(
      int personEditing,
      String? personEditing_name,
      int roomId,
      List<RoomMemberDto> personsToAdd,
      String? welcomeMsg,
      List<RoomMemberDto> personsToRemove,
      String? goodByeMsg) {
    final msig =
        'sendEditRoomMembers($roomId, +${personsToAdd.length} +${personsToRemove.length})';
    if (!isConnected(msig)) return;

    final json = EditRoomMembersDto(
      personEditing: personEditing,
      personEditing_name: personEditing_name,
      roomId: roomId,
      personsToAdd: personsToAdd,
      welcomeMsg: welcomeMsg,
      personsToRemove: personsToRemove,
      goodByeMsg: goodByeMsg,
    ).toJson();
    connectionState.socket.emit("editRoomMembers", json);
    StaticLogger.append('<< EDIT_ROOM_MEMBERS [$json]');
  }

  void sendFindPersons(String keyword, int roomId) {
    final msig = 'sendFindPersons($keyword, $roomId)';
    if (!isConnected(msig)) return;

    incomingState.waitingForPersonsFound = true;
    incomingState.personsFound = null;
    final json = FindPersonsDto(keyword: keyword, roomId: roomId).toJson();
    connectionState.socket.emit("findPersons", json);
    StaticLogger.append('<< FIND_PERSONS [$json]');
  }
}
