import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'message_dto.dart';
import 'room_dto.dart';

import '../common/user_dto.dart';
import '../outgoing/outgoing_handlers.dart';

import '../../utils/static_logger.dart';
import '../../views/chat/message_item.dart';

final incomingStateProvider =
    ChangeNotifierProvider<IncomingState>((ref) => IncomingState());

class IncomingState extends ChangeNotifier {
  late OutgoingHandlers outgoingHandlers;

  UserDto? _user;
  UserDto get user => _user!;
  int get userId => _user?.id ?? -1;
  bool isMyUserId(int id) => id == userId;
  String get userName => _user?.name ?? "USER_DTO_NOT_YET_RECEIVED";
  set user(UserDto val) {
    _user = val;
    notifyListeners();
  }

  String _typing = '';
  String get typing => _typing;
  set typing(String val) {
    _typing = val;
    notifyListeners();
  }

  final Map<int, MessageDto> messagesById = <int, MessageDto>{};
  final Map<int, MessageItem> messageItemsById = <int, MessageItem>{};
  // Iterable<MessageItem> get getMessageItems => _messageItemsById.values;
  final List<MessageItem> messageItems = [];
  List<MessageItem> get getMessageItems => messageItems;

  final Map<int, RoomDto> roomsById = <int, RoomDto>{};
  List<RoomDto> get rooms => roomsById.values.toList();

  int _currentRoomId = 0;
  int get currentRoomId => _currentRoomId;
  set currentRoomId(int val) {
    if (!roomsById.containsKey(val)) {
      StaticLogger.append(
          'CANT_SET_CURRENT_ROOM_BY_ID[$val], _roomsById.keys=[${roomsById.keys}]');
      return;
    }
    if (_currentRoomId == val) {
      StaticLogger.append(
          'SAME_CURRENT_ROOM_BY_ID[$val], _currentRoomId=[$_currentRoomId}]');
      return;
    }
    _currentRoomId = val;

    messagesById.clear();
    outgoingHandlers.sendGetMessages(_currentRoomId, 0);

    notifyListeners();
  }

  RoomDto get currentRoom {
    if (roomsById.containsKey(currentRoomId)) {
      return roomsById[currentRoomId]!;
    } else {
      StaticLogger.append(
          'CANT_GET_ROOM_BY_ID[$currentRoomId], rooms.length=[${rooms.length}]');
      return RoomDto(id: 999, name: '<NO_ROOMS_RECEIVED>', users: []);
    }
  }

  String get currentRoomUsersCsv {
    return currentRoom.users.map((x) => x.name).join(", ");
  }
}
