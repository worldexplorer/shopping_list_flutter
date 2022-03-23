import 'package:shopping_list_flutter/network/incoming/person/registration_confirmed_dto.dart';

import '../../utils/static_logger.dart';
import '../common/typing_dto.dart';
import '../connection_state.dart';
import '../outgoing/outgoing_handlers.dart';
import 'incoming_state.dart';
import 'message/archived_messages_dto.dart';
import 'message/deleted_messages_dto.dart';
import 'message/message_dto.dart';
import 'message/messages_dto.dart';
import 'message/update_messages_read_dto.dart';
import 'person/person_dto.dart';
import 'person/registration_needs_code_dto.dart';
import 'room/room_dto.dart';
import 'room/rooms_dto.dart';

class IncomingHandlers {
  ConnectionState connectionState;
  IncomingState incomingState;
  OutgoingHandlers outgoingHandlers;

  IncomingHandlers(
      this.connectionState, this.incomingState, this.outgoingHandlers);

  void onRegistrationNeedsCode(data) {
    try {
      StaticLogger.append('   > REGISTRATION_NEEDS_CODE [$data]');
      final needsCode = RegistrationNeedsCodeDto.fromJson(data);
      incomingState.needsCode = needsCode;
    } catch (e) {
      StaticLogger.append(
          '      FAILED onRegistrationNeedsCode($data): ${e.toString()}');
    }
  }

  void onRegistrationConfirmed(data) {
    try {
      StaticLogger.append('   > REGISTRATION_CONFIRMED [$data]');
      final auth = RegistrationConfirmedDto.fromJson(data);
      incomingState.auth = auth.auth;
    } catch (e) {
      StaticLogger.append(
          '      FAILED onRegistrationConfirmed($data): ${e.toString()}');
    }
  }

  void onPerson(data) {
    try {
      StaticLogger.append('   > PERSON [$data]');
      final personParsed = PersonDto.fromJson(data);
      incomingState.personReceived = personParsed;
    } catch (e) {
      StaticLogger.append('      FAILED onPerson($data): ${e.toString()}');
    }
  }

  void onRooms(data) {
    StaticLogger.append('   > ROOMS [$data]');
    try {
      RoomsDto roomsParsed = RoomsDto.fromJson(data);

      // var changed = false;
      // var firstRoomId = 0;
      for (int i = 1; i <= roomsParsed.rooms.length; i++) {
        RoomDto room = roomsParsed.rooms[i - 1];
        // if (firstRoomId == 0) {
        //   firstRoomId = room.id;
        // }

        if (incomingState.rooms.roomsById.containsKey(room.id)) {
          StaticLogger.append(
              '      DUPLICATE onRooms(): ${room.id}: ${room.name}');
          continue;
        }

        StaticLogger.append(
            '   > ROOM $i/${roomsParsed.rooms.length} [${room.toJson()}]');

        incomingState.rooms.roomsById[room.id] = room;

        // changed = true;
      }

      // if (changed) {
      //   if (incomingState.currentRoomId == 0) {
      //     incomingState.currentRoomId =
      //         firstRoomId; // will trigger sendGetMessages()
      //   } else {
      //     incomingState.notifyListeners();
      //   }
      // } else {
      //   if (connectionState.willGetMessagesOnReconnect) {
      //     outgoingHandlers.sendGetMessages(incomingState.currentRoomId, 0);
      //     connectionState.willGetMessagesOnReconnect = false;
      //   }
      // }
      incomingState.notifyListeners();
    } catch (e) {
      StaticLogger.append('      FAILED onRooms(): ${e.toString()}');
    }
  }

  void onRoom(data) {
    StaticLogger.append('   > ROOM [$data]');
    try {
      RoomDto roomParsed = RoomDto.fromJson(data);

      if (incomingState.rooms.roomsById.containsKey(roomParsed.id)) {
        StaticLogger.append(
            '      DUPLICATE onRooms(): ${roomParsed.id}: ${roomParsed.name}');
        return;
      }

      StaticLogger.append('   > ROOM [${roomParsed.toJson()}]');
      incomingState.rooms.roomsById[roomParsed.id] = roomParsed;
      incomingState.notifyListeners();
    } catch (e) {
      StaticLogger.append('      FAILED onRoom(): ${e.toString()}');
    }
  }

  void onTyping(data) {
    try {
      final typingDto = TypingDto.fromJson(data);
      if (typingDto.userName == incomingState.personName) {
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
      final msig =
          ' onMessage(): msgId[${msg.id}] ${msg.user_name}: ${msg.content}';

      bool rebuildUi = incomingState.rooms.messageAddOrEdit(msg, msig, true);

      if (rebuildUi) {
        incomingState.notifyListeners();
        StaticLogger.append('         UI REBUILT onMessage()');
      }
    } catch (e) {
      StaticLogger.append('      FAILED onMessage(): ${e.toString()}');
    }
  }

  void onMessages(data) {
    // StaticLogger.append('   > MESSAGES [SEE_BELOW]');
    StaticLogger.append('   > MESSAGES [$data]');
    int i = 0;
    int total = 0;

    try {
      MessagesDto msgs = MessagesDto.fromJson(data);

      int addedOrChangedCounter = 0;

      i = 1;
      total = msgs.messages.length;

      int roomId = 0;
      for (; i <= total; i++) {
        final counter = '$i/$total';
        MessageDto msg = msgs.messages[i - 1];
        final msig =
            ' onMessages($counter/$total): msgId[${msg.id}] ${msg.user_name}: ${msg.content}';

        roomId = msg.id;
        final addedOrChanged = incomingState.rooms.messageAddOrEdit(msg, msig);
        if (addedOrChanged) {
          addedOrChangedCounter++;
        }
      }

      final roomMessages = incomingState.rooms.getRoomMessagesForRoom(roomId);
      if (roomMessages != null) {
        roomMessages!.filledInitially = true;
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

        final MessageDto? existingMsg =
            incomingState.rooms.currentRoomMessages.messageDtoById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
          throw 'messagesById[msg.id] NOT FOUND';
        }

        final log = incomingState.rooms.currentRoomMessages
            .removeMessageFromMessagesUnreadById(msgId);

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

        final MessageDto? existingMsg =
            incomingState.rooms.currentRoomMessages.messageDtoById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
        }

        final log = incomingState.rooms.currentRoomMessages
            .removeMessageFromAllMaps(msgId);
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

        final MessageDto? existingMsg =
            incomingState.rooms.currentRoomMessages.messageDtoById[msgId];
        if (existingMsg == null) {
          StaticLogger.append('      $msig: messagesById[$msgId] NOT FOUND');
          continue;
        }

        final log = incomingState.rooms.currentRoomMessages
            .removeMessageFromAllMaps(msgId);
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
