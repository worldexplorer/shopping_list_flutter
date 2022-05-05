import '../network/incoming/message/message_dto.dart';
import '../network/incoming/purchase/pur_item_filled_dto.dart';
import '../network/incoming/room/room_dto.dart';
import '../network/incoming/room/room_member_dto.dart';
import '../network/outgoing/outgoing_handlers.dart';
import '../notifications/notifications_plugin.dart';
import '../utils/static_logger.dart';
import 'room_messages.dart';

class Rooms {
  final Map<int, RoomDto> roomById = <int, RoomDto>{};
  List<RoomDto> get roomsSnapList => roomById.values.toList();

  OutgoingHandlers outgoingHandlers;
  int myPersonId;
  Function(String err) setClientError;
  Rooms(
      {required this.outgoingHandlers,
      required this.myPersonId,
      required this.setClientError});

  void clearAllRooms() {
    roomById.clear();
    currentRoomMessages.clearAllMessages();
  }

  int _currentRoomId = 0;
  int get currentRoomId => _currentRoomId;
  RoomDto? get currentRoomDto {
    if (roomById.containsKey(currentRoomId)) {
      return roomById[currentRoomId]!;
    } else {
      StaticLogger.append(
          'ROOM_WILL_BE_ADDED[$currentRoomId] on data arrival in onRoom()/onRooms()');
      // return RoomDto(id: 999, name: 'NO_ROOM_RECEIVED:[$currentRoomId]', users: []);
      return null;
    }
  }

  String get currentRoomNameOrFetching {
    return currentRoomDto != null ? currentRoomDto!.name : 'Fetching...';
  }

  List<RoomMemberDto> get currentRoomUsersOrEmpty {
    return currentRoomDto != null ? currentRoomDto!.members : [];
  }

  bool get canEditCurrentRoom {
    if (currentRoomDto != null) {
      final iCanEdit = currentRoomDto!.members
          .where((x) => x.person == myPersonId)
          .isNotEmpty;
      return iCanEdit;
    } else {
      return false;
    }
  }

  RoomMessages getOrCreateRoom(int roomId, String msig, [Function? onAdded]) {
    if (!_messagesByRoom.containsKey(roomId)) {
      _messagesByRoom.putIfAbsent(
          roomId,
          () => RoomMessages(
              myPersonId: myPersonId, setClientError: setClientError));
      StaticLogger.append(msig);
      if (onAdded != null) {
        onAdded();
      }
    }
    return _messagesByRoom[roomId]!;
  }

  bool setCurrentRoomId(int newRoomId) {
    const msig = ' //Rooms.setCurrentRoomId()';
    bool shouldRequestBackend = false;

    if (!roomById.containsKey(newRoomId)) {
      StaticLogger.append(
          'CANT_SET_CURRENT_ROOM_BY_ID[$newRoomId], _roomsById.keys=[${roomById.keys}] ${msig}');
      return shouldRequestBackend;
    }
    if (_currentRoomId == newRoomId) {
      StaticLogger.append(
          'NOT_REQUESTING_SAME_CURRENT_ROOM[$newRoomId], _currentRoomId=[$_currentRoomId}] ${msig}');
      return shouldRequestBackend;
    }
    _currentRoomId = newRoomId;

    getOrCreateRoom(_currentRoomId,
        'EMPTY_MESSAGES_ADDED_ON_SWITCH_TO_EMPTY_ROOM[$_currentRoomId] ${msig}',
        () {
      // outgoingHandlers.sendGetMessages(_currentRoomId);
      shouldRequestBackend = true;
    });

    return shouldRequestBackend;
  }

  String get currentRoomUsersCsv {
    return currentRoomUsersOrEmpty.map((x) => x.person_name).join(", ");
  }

  int isEditingMessageId = 0;

  final Map<int, RoomMessages> _messagesByRoom = <int, RoomMessages>{};
  RoomMessages get currentRoomMessages {
    return getOrCreateRoom(currentRoomId,
        'ADD_ROOM_MESSAGES_IMPLICITLY[$currentRoomId], _currentRoomId=[$_currentRoomId}]');
  }

  RoomMessages? getRoomMessagesForRoom(int roomId) {
    return _messagesByRoom[roomId];
  }

  bool messageAddOrEdit(MessageDto msgReceived, String msig,
      [bool fireNotification = false]) {
    final roomId = msgReceived.room;
    final roomMessages = getOrCreateRoom(roomId,
        'EMPTY_MESSAGES_ADDED_ON_NEW_MESSAGE[$roomId] _currentRoomId=[$_currentRoomId] //messageAddOrEdit()');

    bool rebuildUi =
        roomMessages.messageAddOrEdit(msgReceived, isEditingMessageId, msig);

    if (roomId != currentRoomId) {
      final msg = 'msgReceived.room[$roomId] != currentRoomId[$currentRoomId]';
      StaticLogger.append('          MESSAGE_ADDED_TO_NON_CURRENT_ROOM $msg');
    }

    if (msgReceived.user != myPersonId && fireNotification) {
      RoomDto? room = roomById[roomId];
      RoomMemberDto? author =
          room?.members.firstWhere((x) => x.person == msgReceived.user);
      String roomName = room != null ? room.name : 'ROOM_NAME_UNKNOWN';
      NotificationsPlugin.instance.notificator
          .showIncomingMessage(msgReceived, roomName, author);
    }

    return rebuildUi;
  }

  bool purItemFilled(PurItemFilledDto purItemFilled, String msig,
      [bool fireNotification = false]) {
    final roomId = purItemFilled.room;
    final roomMessages = getOrCreateRoom(roomId,
        'EMPTY_MESSAGES_ADDED_ON_PURITEM_FILLED[$roomId] _currentRoomId=[$_currentRoomId] //messageAddOrEdit()');
    bool rebuildUi =
        roomMessages.purItemFilled(purItemFilled, isEditingMessageId, msig);

    if (roomId != currentRoomId) {
      final msg =
          'purItemFilled.room[$roomId] != currentRoomId[$currentRoomId]';
      StaticLogger.append('          PURITEM_FILLED_IN_NON_CURRENT_ROOM $msg');
    }

    if (purItemFilled.person_bought != myPersonId && fireNotification) {
      RoomDto? room = roomById[purItemFilled.room];
      RoomMemberDto? author = room?.members
          .firstWhere((x) => x.person == purItemFilled.person_bought);
      String roomName = room != null ? room.name : 'ROOM_NAME_UNKNOWN';
      NotificationsPlugin.instance.notificator
          .showPurItemFilled(purItemFilled, roomName, author);
    }

    return rebuildUi;
  }
}
