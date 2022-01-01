import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../connection.dart';
import '../outgoing/outgoing_handlers.dart';
import 'message_dto.dart';
import 'room_dto.dart';
import 'user_dto.dart';

import '../../utils/static_logger.dart';
import '../../views/chat/message_item.dart';

final incomingStateProvider =
    ChangeNotifierProvider<IncomingState>((ref) => IncomingState());

class IncomingState extends ChangeNotifier {
  late OutgoingHandlers outgoingHandlers;
  late Connection connection;

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

  final Map<int, MessageDto> messagesUnreadById = <int, MessageDto>{};
  List<int> getOnlyUnreadMessages() {
    final List<MessageDto> all = messagesUnreadById.values.toList();
    final List<MessageDto> unread =
        all.where((x) => !x.persons_read.contains(userId)).toList();
    final List<int> unreadMsgIds = unread.map((y) => y.id).toList();
    return unreadMsgIds;
  }

  final Map<int, MessageDto> messagesById = <int, MessageDto>{};
  final Map<int, MessageItem> messageItemsById = <int, MessageItem>{};
  // Iterable<MessageItem> get getMessageItems => _messageItemsById.values;
  final List<MessageItem> messageItems = [];
  List<MessageItem> get getMessageItems => messageItems;

  clearAllMessages() {
    messagesUnreadById.clear();
    messagesById.clear();
    messageItemsById.clear();
    messageItems.clear();
    notifyListeners();
  }

  String removeMessageFromMessagesUnreadById(int msgId) {
    var log = '';

    if (messagesUnreadById.containsKey(msgId)) {
      messagesUnreadById.remove(msgId);
      log += ' REMOVED from messagesUnreadById;';
    } else {
      log += ' NOT_FOUND_IN messagesUnreadById;';
    }

    return log;
  }

  String removeMessageFromAllMaps(int msgId) {
    var log = '';

    if (messagesById.containsKey(msgId)) {
      messagesById.remove(msgId);
      log += ' REMOVED from messagesById;';
    } else {
      log += ' NOT_FOUND_IN messagesById;';
    }

    if (messagesUnreadById.containsKey(msgId)) {
      messagesUnreadById.remove(msgId);
      log += ' REMOVED from messagesUnreadById;';
    } else {
      log += ' NOT_FOUND_IN messagesUnreadById;';
    }

    if (messageItemsById.containsKey(msgId)) {
      messageItemsById.remove(msgId);
      log += ' REMOVED from messageItemsById;';
    } else {
      log += ' NOT_FOUND_IN messageItemsById;';
    }

    final indexFound = messageItems.indexWhere((x) => x.message.id == msgId);
    if (indexFound >= 0) {
      messageItems.removeAt(indexFound);
      log += ' REMOVED from messageItems;';
    } else {
      log += ' NOT_FOUND_IN messageItems;';
    }
    return log;
  }

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
