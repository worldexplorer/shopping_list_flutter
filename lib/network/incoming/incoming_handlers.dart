import 'package:flutter/material.dart';

import '../common/typing_dto.dart';
import '../common/user_dto.dart';

import '../outgoing/outgoing_handlers.dart';

import '../../utils/static_logger.dart';
import '../../views/chat/message_item.dart';

import '../connection_state.dart';
import 'incoming_state.dart';
import 'message_dto.dart';
import 'room_dto.dart';
import 'update_message_read_dto.dart';
import 'messages_dto.dart';
import 'rooms_dto.dart';

class IncomingHandlers {
  ConnectionState1 connectionState;
  IncomingState incomingState;
  OutgoingHandlers outgoingHandlers;

  IncomingHandlers(
      this.connectionState, this.incomingState, this.outgoingHandlers);

  void onUser(data) {
    try {
      StaticLogger.append('   > USER [$data]');
      final userParsed = UserDto.fromJson(data);
      incomingState.user = userParsed;
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

        if (incomingState.roomsById.containsKey(room.id)) {
          StaticLogger.append(
              '      DUPLICATE onRooms(): ${room.id}: ${room.name}');
          continue;
        }

        StaticLogger.append(
            '   > ROOM $i/${roomsParsed.rooms.length} [${room.toJson()}]');

        incomingState.roomsById[room.id] = room;

        changed = true;
      }

      if (changed) {
        if (incomingState.currentRoomId == 0) {
          incomingState.currentRoomId =
              firstRoomId; // will trigger sendGetMessages()
        } else {
          incomingState.notifyListeners();
        }
      } else {
        if (connectionState.willGetMessagesOnReconnect) {
          outgoingHandlers.sendGetMessages(incomingState.currentRoomId, 0);
          connectionState.willGetMessagesOnReconnect = false;
        }
      }
    } catch (e) {
      StaticLogger.append('      FAILED onRooms(): ${e.toString()}');
    }
  }

  void onTyping(data) {
    try {
      final typingDto = TypingDto.fromJson(data);
      if (typingDto.userName == incomingState.userName) {
        return;
      }

      if (typingDto.typing) {
        incomingState.typing = '${typingDto.userName} is typing...';
      } else if (!typingDto.typing) {
        incomingState.typing = '';
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

      bool rebuildUi = _messageAddOrEdit(msg, msig);

      outgoingHandlers.sendMarkMessageRead(msg.id, incomingState.userId);

      if (rebuildUi) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append('      FAILED onMessage(): ${e.toString()}');
    }
  }

  bool _messageAddOrEdit(MessageDto msg, String msig) {
    bool changed = false;

    final prevMsg = incomingState.messagesById[msg.id];
    if (prevMsg == null) {
      final widget = MessageItem(
        key: const Key('aaa'),
        isMe: incomingState.isMyUserId(msg.user),
        message: msg,
      );

      incomingState.messagesById[msg.id] = msg;
      incomingState.messageItemsById[msg.id] = widget;
      incomingState.messageItems.insert(0, widget);

      changed = true;
    } else {
      String changes = '';
      if (prevMsg.content != msg.content) {
        changes += '[${prevMsg.content}]=>[${msg.content}] ';
      }
      if (prevMsg.edited != msg.edited) {
        changes += 'edited[${msg.edited}] ';
      }
      if (prevMsg.purchase != msg.purchase) {
        String prevPurchase = prevMsg.purchase?.name ?? 'NONE';
        String purchase = msg.purchase?.name ?? 'NONE';
        changes += 'purchase[$prevPurchase]=>[$purchase] ';
      }
      if (changes == '') {
        StaticLogger.append('      NOT_CHANGED $msig');
      } else {
        StaticLogger.append('      EDITED $msig: $changes');
        changed = true;
      }
      incomingState.messagesById[msg.id] = msg;

      var widget = incomingState.messageItemsById[msg.id];
      if (widget != null) {
        // no need to find widget in messageItems and re-insert a new instance
        widget.message = msg;
      }
    }

    return changed;
  }

  void onMessages(data) {
    StaticLogger.append('   > MESSAGES [SEE_BELOW]');
    int i = 1;
    int total = 0;

    try {
      MessagesDto msgs = MessagesDto.fromJson(data);

      var changed = false;
      i = 1;
      total = msgs.messages.length;

      for (; i <= total; i++) {
        final counter = '$i/$total';
        MessageDto msg = msgs.messages[i - 1];
        final msig = ' onMessages($counter): ${msg.user_name}: ${msg.content}';

        changed &= _messageAddOrEdit(msg, msig);
      }

      if (changed) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '   > MESSAGES FAILED onMessages($i/$total): ${e.toString()}');
    }
  }

  void onUpdateMessageRead(data) {
    StaticLogger.append('> UPDATE_MESSAGE_READ [$data]');
    try {
      UpdatedMessageReadDto msg = UpdatedMessageReadDto.fromJson(data);
      final msig = ' onUpdateMessageRead(): ${msg.id}: ${msg.persons_read}';

      final MessageDto? existingMsg = incomingState.messagesById[msg.id];
      if (existingMsg == null) {
        throw 'messagesById[msg.id] NOT FOUND';
      } else {
        StaticLogger.append(
            '      MESSAGE_READ_UPDATED $msig: [$existingMsg] => [$msg]');
        existingMsg.persons_read = msg.persons_read;
        // no need to find widget in messageItems and re-insert a new instance
      }

      incomingState.notifyListeners();
    } catch (e) {
      StaticLogger.append(
          '      FAILED onUpdateMessageRead(): ${e.toString()}');
    }
  }

  void onServerError(data) {
    StaticLogger.append('> SERVER_ERROR [$data]');
  }
}
