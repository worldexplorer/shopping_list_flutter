import 'package:flutter/material.dart';
import 'package:shopping_list_flutter/network/dto/messages.dart';
import 'package:shopping_list_flutter/network/dto/typing.dart';
import 'package:shopping_list_flutter/network/dto/user.dart';
import 'package:shopping_list_flutter/network/incoming/rooms.dart';
import 'package:shopping_list_flutter/widget/message_item.dart';

import '../connection_notifier.dart';

class IncomingNotifier extends ChangeNotifier {
  User? _user;
  User get user => _user!;
  String get userName => _user?.name ?? "USER_DTO_NOT_YET_RECEIVED";
  set user(User val) {
    _user = val;
    notifyListeners();
  }

  String _typing = '';
  String get typing => _typing;
  set typing(String val) {
    _typing = val;
    notifyListeners();
  }

  List<MessageItem> _messages = [];
  List<MessageItem> get messages => _messages;
  set messages(List<MessageItem> val) {
    _messages = val;
    notifyListeners();
  }

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;
  set rooms(List<Room> val) {
    _rooms = val;
    notifyListeners();
  }

  int _currentRoomIndex = 0;
  int get currentRoomIndex => _currentRoomIndex;
  set currentRoomIndex(int val) {
    _currentRoomIndex = val;
    notifyListeners();
  }

  Room get currentRoom {
    try {
      return rooms[currentRoomIndex];
    } catch (e) {
      debugPrint(
          'CANT_GET_ROOM_BY_INDEX[$currentRoomIndex], rooms.length=[${rooms.length}]: ${e.toString()}');
      return Room(id: 999, name: '<NO_ROOMS_RECEIVED>', users: []);
    }
  }

  ConnectionNotifier connectionNotifier;
  IncomingNotifier(this.connectionNotifier);

  void onUser(data) {
    try {
      final userParsed = User.fromJson(data);
      user = userParsed;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onRooms(data) {
    try {
      final roomsParsed = Rooms.fromJson(data);
      rooms = roomsParsed.rooms;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onTyping(data) {
    final typingDto = Typing.fromJson(data);

    final imTyping = connectionNotifier.isMySocketId(typingDto.socketId);
    if (imTyping) {
      return;
    }

    if (typingDto.typing) {
      typing = '${typingDto.userName} is typing...';
    } else if (!typingDto.typing) {
      typing = '';
    }
  }

  void onNewMessage(data) {
    try {
      Message msg = Message.fromJson(data);
      debugPrint('onNewMessage(): [$msg]');

      if (!connectionNotifier.isMySocketId(msg.id)) {
        debugPrint('${msg.username}: ${msg.message}');
      }
      messages.insert(
        0,
        MessageItem(
          isMe: connectionNotifier.isMySocketId(msg.id),
          message: msg,
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
