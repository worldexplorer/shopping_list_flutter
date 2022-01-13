import '../../utils/static_logger.dart';
import '../common/typing_dto.dart';
import '../outgoing/outgoing_handlers.dart';
import '../connection_state.dart';

import 'archived_messages_dto.dart';
import 'user_dto.dart';
import 'deleted_messages_dto.dart';
import 'incoming_state.dart';
import 'message_dto.dart';
import 'room_dto.dart';
import 'update_messages_read_dto.dart';
import 'messages_dto.dart';
import 'rooms_dto.dart';

class IncomingHandlers {
  ConnectionState connectionState;
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

      bool rebuildUi = incomingState.messageAddOrEdit(msg, msig);

      if (rebuildUi) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append('      FAILED onMessage(): ${e.toString()}');
    }
  }

  void onMessages(data) {
    StaticLogger.append('   > MESSAGES [SEE_BELOW]');
    int i = 1;
    int total = 0;

    try {
      MessagesDto msgs = MessagesDto.fromJson(data);

      int addedOrChangedCounter = 0;

      i = 1;
      total = msgs.messages.length;

      for (; i <= total; i++) {
        final counter = '$i/$total';
        MessageDto msg = msgs.messages[i - 1];
        final msig = ' onMessages($counter): ${msg.user_name}: ${msg.content}';

        final addedOrChanged = incomingState.messageAddOrEdit(msg, msig);
        if (addedOrChanged) {
          addedOrChangedCounter++;
        }
      }

      if (addedOrChangedCounter > 0) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '   > MESSAGES FAILED onMessages($i/$total): ${e.toString()}');
    }
  }

  void onMessagesReadUpdated(data) {
    StaticLogger.append('> MESSAGES_READ_UPDATED [$data]');
    int messagesRead = 0;
    int i = 1;
    int total = 0;

    try {
      UpdatedMessagesReadDto msgsRead = UpdatedMessagesReadDto.fromJson(data);

      i = 1;
      total = msgsRead.messagesUpdated.length;

      for (; i <= total; i++) {
        final counter = '$i/$total';
        UpdatedMessageReadDto msg = msgsRead.messagesUpdated[i - 1];

        final msgId = msg.id;
        final msig =
            ' onMessagesReadUpdated($counter): $msgId: ${msg.persons_read}';

        final MessageDto? existingMsg = incomingState.messagesById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
          throw 'messagesById[msg.id] NOT FOUND';
        }

        final log = incomingState.removeMessageFromMessagesUnreadById(msgId);

        StaticLogger.append('      MESSAGE_READ_UPDATED $msig: '
            '[${existingMsg.persons_read}] => [${msg.persons_read}]'
            ' $log');
        existingMsg.persons_read = msg.persons_read;
      }

      if (msgsRead.messagesUpdated.isNotEmpty) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '      FAILED onMessagesReadUpdated(): ${e.toString()}');
    }
  }

  void onArchivedMessages(data) {
    StaticLogger.append('> ARCHIVED_MESSAGES [$data]');
    int messagesArchived = 0;
    int i = 1;
    int total = 0;

    try {
      ArchivedMessagesDto msgsArchived = ArchivedMessagesDto.fromJson(data);

      i = 1;
      total = msgsArchived.messageIds.length;

      for (; i <= total; i++) {
        final counter = '$i/$total';
        int msgId = msgsArchived.messageIds[i - 1];
        final msig = ' onArchivedMessages($counter): $msgId';

        final MessageDto? existingMsg = incomingState.messagesById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
        }

        final log = incomingState.removeMessageFromAllMaps(msgId);
        if (log != '') {
          messagesArchived++;
        }

        StaticLogger.append('      ARCHIVED_MESSAGE $msig: $log');
      }

      if (messagesArchived > 0) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '      FAILED onArchivedMessages($i/$total): ${e.toString()}');
    }
  }

  void onDeletedMessages(data) {
    StaticLogger.append('> DELETED_MESSAGES [$data]');
    int messagesDeleted = 0;
    int i = 1;
    int total = 0;

    try {
      DeletedMessagesDto msgsDeleted = DeletedMessagesDto.fromJson(data);

      i = 1;
      total = msgsDeleted.messageIds.length;

      for (; i <= total; i++) {
        final counter = '$i/$total';
        int msgId = msgsDeleted.messageIds[i - 1];
        final msig = ' onDeletedMessages($counter): $msgId';

        final MessageDto? existingMsg = incomingState.messagesById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
        }

        final log = incomingState.removeMessageFromAllMaps(msgId);
        if (log != '') {
          messagesDeleted++;
        }

        StaticLogger.append('      DELETED_MESSAGE $msig: $log');
      }

      if (messagesDeleted > 0) {
        incomingState.notifyListeners();
      }
    } catch (e) {
      StaticLogger.append(
          '      FAILED onDeletedMessages($i/$total): ${e.toString()}');
    }
  }

  void onServerError(data) {
    StaticLogger.append('> SERVER_ERROR [$data]');
    incomingState.serverError = '$data';
  }
}
