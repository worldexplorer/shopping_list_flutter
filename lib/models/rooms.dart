import 'package:shopping_list_flutter/network/outgoing/outgoing_handlers.dart';
import 'package:shopping_list_flutter/notifications/notifications_plugin.dart';

import '../network/incoming/message/message_dto.dart';
import '../network/incoming/person/person_dto.dart';
import '../network/incoming/room/room_dto.dart';
import '../utils/static_logger.dart';
import 'room_messages.dart';

class Rooms {
  final Map<int, RoomDto> roomsById = <int, RoomDto>{};
  List<RoomDto> get roomsSnapList => roomsById.values.toList();

  OutgoingHandlers backend;
  int myPersonId;
  Function(String err) setClientError;
  Rooms(
      {required this.backend,
      required this.myPersonId,
      required this.setClientError});

  void clearAllRooms() {
    roomsById.clear();
    currentRoomMessages.clearAllMessages();
  }

  int _currentRoomId = 0;
  int get currentRoomId => _currentRoomId;
  RoomDto get currentRoomDto {
    if (roomsById.containsKey(currentRoomId)) {
      return roomsById[currentRoomId]!;
    } else {
      StaticLogger.append(
          'ROOM_WAS_NOT_ADDED_ID[$currentRoomId], length=[${roomsById.length}]');
      return RoomDto(id: 999, name: '<NO_ROOMS_RECEIVED>', users: []);
    }
  }

  bool setCurrentRoomId(int val) {
    if (!roomsById.containsKey(val)) {
      StaticLogger.append(
          'CANT_SET_CURRENT_ROOM_BY_ID[$val], _roomsById.keys=[${roomsById.keys}]');
      return false;
    }
    if (_currentRoomId == val) {
      StaticLogger.append(
          'NOT_REQUESTING_SAME_CURRENT_ROOM[$val], _currentRoomId=[$_currentRoomId}]');
      return false;
    }
    _currentRoomId = val;

    if (!_messagesByRoom.containsKey(_currentRoomId)) {
      _messagesByRoom.putIfAbsent(
          _currentRoomId,
          () => RoomMessages(
              myPersonId: myPersonId, setClientError: setClientError));
      StaticLogger.append(
          'EMPTY_MESSAGES_ADDED_ON_SWITCH_TO_EMPTY_ROOM[$_currentRoomId] //setCurrentRoom()');
      backend.sendGetMessages(_currentRoomId);
    }
    return true;
  }

  String get currentRoomUsersCsv {
    return currentRoomDto.users.map((x) => x.name).join(", ");
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

    if (fireNotification) {
      PersonDto? author;
      RoomDto? room = roomsById[msgReceived.room];
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
