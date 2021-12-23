import 'package:flutter/foundation.dart';
import 'package:shopping_list_flutter/network/common/message_dto.dart';
import 'package:shopping_list_flutter/network/common/typing_dto.dart';
import 'package:shopping_list_flutter/network/common/user_dto.dart';
import 'package:shopping_list_flutter/network/incoming/room_dto.dart';
import 'package:shopping_list_flutter/network/outgoing/outgoing_notifier.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/widget/message_item.dart';

import '../connection_notifier.dart';
import 'messages_dto.dart';
import 'rooms_dto.dart';

class IncomingNotifier extends ChangeNotifier {
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

  final Map<int, MessageDto> _messagesById = <int, MessageDto>{};
  final Map<int, MessageItem> _messageItemsById = <int, MessageItem>{};
  // Iterable<MessageItem> get getMessageItems => _messageItemsById.values;
  final List<MessageItem> _messageItems = <MessageItem>[];
  List<MessageItem> get getMessageItems => _messageItems;

  final Map<int, RoomDto> _roomsById = <int, RoomDto>{};
  List<RoomDto> get rooms => _roomsById.values.toList();

  int _currentRoomId = 0;
  int get currentRoomId => _currentRoomId;
  set currentRoomId(int val) {
    if (!_roomsById.containsKey(val)) {
      StaticLogger.append(
          'CANT_SET_CURRENT_ROOM_BY_ID[$val], _roomsById.keys=[${_roomsById.keys}]');
      return;
    }
    if (_currentRoomId == val) {
      StaticLogger.append(
          'SAME_CURRENT_ROOM_BY_ID[$val], _currentRoomId=[$_currentRoomId}]');
      return;
    }
    _currentRoomId = val;

    _messagesById.clear();
    outgoingNotifier.sendGetMessages(_currentRoomId, 0);

    notifyListeners();
  }

  RoomDto get currentRoom {
    if (_roomsById.containsKey(currentRoomId)) {
      return _roomsById[currentRoomId]!;
    } else {
      StaticLogger.append(
          'CANT_GET_ROOM_BY_ID[$currentRoomId], rooms.length=[${rooms.length}]');
      return RoomDto(id: 999, name: '<NO_ROOMS_RECEIVED>', users: []);
    }
  }

  String get currentRoomUsersCsv {
    return currentRoom.users.map((x) => x.name).join(", ");
  }

  late OutgoingNotifier outgoingNotifier;
  ConnectionNotifier connectionNotifier;
  IncomingNotifier(this.connectionNotifier);

  void onUser(data) {
    try {
      StaticLogger.append('   > USER [$data]');
      final userParsed = UserDto.fromJson(data);
      user = userParsed;
    } catch (e) {
      StaticLogger.append('      FAILED onUser($data): ${e.toString()}');
    }
  }

  void onRooms(data) {
    StaticLogger.append('   > ROOMS [$data]');
    try {
      RoomsDto roomsParsed = RoomsDto.fromJson(data);

      var changed = false;
      var firstRoomId = 0;
      for (int i = 1; i <= roomsParsed.rooms.length; i++) {
        RoomDto room = roomsParsed.rooms[i - 1];
        if (firstRoomId == 0) {
          firstRoomId = room.id;
        }

        if (_roomsById.containsKey(room.id)) {
          StaticLogger.append(
              '      DUPLICATE onRooms(): ${room.id}: ${room.name}');
          continue;
        }

        StaticLogger.append(
            '   > ROOM $i/${roomsParsed.rooms.length} [${room.toJson()}]');

        _roomsById[room.id] = room;

        changed = true;
      }

      if (changed) {
        if (currentRoomId == 0) {
          currentRoomId = firstRoomId; // will trigger sendGetMessages()
        } else {
          notifyListeners();
        }
      } else {
        if (connectionNotifier.willGetMessagesOnReconnect) {
          outgoingNotifier.sendGetMessages(_currentRoomId, 0);
          connectionNotifier.willGetMessagesOnReconnect = false;
        }
      }
    } catch (e) {
      StaticLogger.append('      FAILED onRooms(): ${e.toString()}');
    }
  }

  void onTyping(data) {
    try {
      final typingDto = TypingDto.fromJson(data);
      if (typingDto.userName == userName) {
        return;
      }

      if (typingDto.typing) {
        typing = '${typingDto.userName} is typing...';
      } else if (!typingDto.typing) {
        typing = '';
      }
    } catch (e) {
      StaticLogger.append('      FAILED onTyping($data): ${e.toString()}');
    }
  }

  void onMessage(data) {
    StaticLogger.append('> MESSAGE [$data]');
    try {
      MessageDto msg = MessageDto.fromJson(data);
      final msig = ' onMessage(): ${msg.user_name}: ${msg.content}';

      var msgItem = MessageItem(
        isMe: isMyUserId(msg.user),
        message: msg,
      );

      if (msg.id == null) {
        StaticLogger.append('      NULL_ID__SERVER_SHOULD_ASSIGN $msig');
      } else {
        if (_messagesById.containsKey(msg.id)) {
          StaticLogger.append('      DUPLICATE $msig');
        } else {
          _messagesById[msg.id!] = msg;
          _messageItemsById[msg.id!] = msgItem;
        }
      }

      _messageItems.insert(0, msgItem);
      notifyListeners();
    } catch (e) {
      StaticLogger.append('      FAILED onMessage(): ${e.toString()}');
    }
  }

  void onError(data) {
    StaticLogger.append('> SERVER_ERROR [$data]');
  }

  void onMessages(data) {
    StaticLogger.append('   > MESSAGES [$data]');
    int i = 1;
    int total = 0;

    try {
      MessagesDto msgs = MessagesDto.fromJson(data);

      var changed = false;
      i = 1;
      total = msgs.messages.length;

      for (; i <= total; i++) {
        final counter = '$i/$total ';
        MessageDto msg = msgs.messages[i - 1];

        if (_messagesById.containsKey(msg.id)) {
          StaticLogger.append(
              '      MESSAGE DUPLICATE $counter: ${msg.user_name}: ${msg.content}');
          continue;
        }

        StaticLogger.append('   > MESSAGE $counter [${msg.toJson()}]');
        final widget = MessageItem(
          isMe: isMyUserId(msg.user),
          message: msg,
        );

        _messagesById[msg.id!] = msg;
        _messageItemsById[msg.id!] = widget;
        _messageItems.insert(0, widget);

        changed = true;
      }

      if (changed) {
        notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '      FAILED onMessages($i/$total): ${e.toString()}');
    }
  }
}
