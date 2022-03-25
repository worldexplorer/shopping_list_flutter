import 'package:shopping_list_flutter/network/outgoing/outgoing_handlers.dart';
import 'package:shopping_list_flutter/notifications/notifications_plugin.dart';

import '../network/incoming/message/message_dto.dart';
import '../network/incoming/person/person_dto.dart';
import '../network/incoming/room/room_dto.dart';
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

  List<PersonDto> get currentRoomUsersOrEmpty {
    return currentRoomDto != null ? currentRoomDto!.users : [];
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

    if (!_messagesByRoom.containsKey(_currentRoomId)) {
      _messagesByRoom.putIfAbsent(
          _currentRoomId,
          () => RoomMessages(
              myPersonId: myPersonId, setClientError: setClientError));
      StaticLogger.append(
          'EMPTY_MESSAGES_ADDED_ON_SWITCH_TO_EMPTY_ROOM[$_currentRoomId] ${msig}');
      // outgoingHandlers.sendGetMessages(_currentRoomId);
      shouldRequestBackend = true;
    }
    return shouldRequestBackend;
  }

  String get currentRoomUsersCsv {
    return currentRoomUsersOrEmpty.map((x) => x.name).join(", ");
  }

  int isEditingMessageId = 0;

  final Map<int, RoomMessages> _messagesByRoom = <int, RoomMessages>{};
  RoomMessages get currentRoomMessages {
    if (!_messagesByRoom.containsKey(currentRoomId)) {
      _messagesByRoom.putIfAbsent(
          currentRoomId,
          () => RoomMessages(
              myPersonId: myPersonId, setClientError: setClientError));
      StaticLogger.append(
          'ADD_ROOM_MESSAGES_IMPLICITLY[$currentRoomId], _currentRoomId=[$_currentRoomId}]');
    }
    return _messagesByRoom[currentRoomId]!;
  }

  RoomMessages? getRoomMessagesForRoom(int roomId) {
    return _messagesByRoom[roomId];
  }

  bool messageAddOrEdit(MessageDto msgReceived, String msig,
      [bool fireNotification = false]) {
    if (!_messagesByRoom.containsKey(msgReceived.room)) {
      _messagesByRoom.putIfAbsent(
          msgReceived.room,
          () => RoomMessages(
              myPersonId: myPersonId, setClientError: setClientError));
      StaticLogger.append(
          'EMPTY_MESSAGES_ADDED_ON_NEW_MESSAGE[$msgReceived.room] _currentRoomId=[$_currentRoomId}] //messageAddOrEdit()');
    }

    final roomMessages = _messagesByRoom[msgReceived.room]!;
    bool rebuildUi =
        roomMessages.messageAddOrEdit(msgReceived, isEditingMessageId, msig);

    if (msgReceived.room != currentRoomId) {
      final msg =
          'msgReceived.room[${msgReceived.room}] != currentRoomId[$currentRoomId]';
      StaticLogger.append('          MESSAGE_ADDED_TO_NON_CURRENT_ROOM $msg');
    }

    if (msgReceived.user != myPersonId && fireNotification) {
      PersonDto? author;
      RoomDto? room = roomById[msgReceived.room];
      if (room != null) {
        author = room.users.firstWhere((x) => x.id == msgReceived.user);
      }
      String roomName = room != null ? room!.name : 'ROOM_NAME_UNKNOWN';
      NotificationsPlugin.instance.notificator
          .showIncomingMessage(msgReceived, roomName, author);
    }

    return rebuildUi;
  }
}
