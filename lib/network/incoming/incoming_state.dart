import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';

import '../connection.dart';
import '../outgoing/outgoing_handlers.dart';
import 'message_dto.dart';
import 'pur_item_dto.dart';
import 'purchase_dto.dart';
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

  String _serverError = '';
  String get serverError => _serverError;
  set serverError(String val) {
    _serverError = val;
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

  bool messageAddOrEdit(MessageDto msg, String msig) {
    bool addedOrChanged = false;

    final prevMsg = messagesById[msg.id];
    if (prevMsg == null) {
      final widget = MessageItem(
        key: Key(msg.id.toString()),
        isMe: isMyUserId(msg.user),
        message: msg,
      );

      messagesById[msg.id] = msg;
      if (!msg.persons_read.contains(userId)) {
        messagesUnreadById[msg.id] = msg;
      }

      messageItemsById[msg.id] = widget;
      messageItems.insert(0, widget);

      addedOrChanged = true;
      StaticLogger.append('      ADDED $msig');

      var purchase = '';
      if (msg.purchase != null) {
        final pur = msg.purchase!;
        purchase += '${pur.name} puritems[${pur.purItems.length}]';
        purchase += pur.purItems.map((PurItemDto x) {
          final qnty =
              (x.punit_fpoint ?? false) ? x.qnty : (x.qnty ?? 0).round();
          return '${x.name}'
              '\t\t${qnty} ${x.punit_brief}'
              '\t\tqnty:${x.qnty}'
              '\t\tpunit:${x.punit_name}(${x.punit_id})'
              '\t\t\t${x.pgroup_name}(${x.pgroup_id})'
              '\t\t${x.product_name}(${x.product_id})';
        }).join('\n\t\t\t\t');
      }

      if (purchase != '') {
        StaticLogger.append('          PURCHASE $purchase');
      }
    } else {
      String changes = '';
      if (prevMsg.content != msg.content) {
        changes += '[${prevMsg.content}]=>[${msg.content}] ';
      }
      if (prevMsg.edited != msg.edited) {
        changes += 'edited[${msg.edited}] ';
      }
      if (prevMsg.purchase?.name != msg.purchase?.name) {
        String prevPurchase = prevMsg.purchase?.name ?? 'NONE';
        String purchase = msg.purchase?.name ?? 'NONE';
        changes += 'purchase[$prevPurchase]=>[$purchase] ';
      }
      if (prevMsg.purchase?.date_updated != msg.purchase?.date_updated) {
        DateTime? prevPurchase = prevMsg.purchase?.date_updated;
        DateTime? purchase = msg.purchase?.date_updated;
        changes += 'purchase.date_updated[$prevPurchase]=>[$purchase] ';
      }
      if (changes == '') {
        StaticLogger.append('      NOT_CHANGED $msig');
      } else {
        StaticLogger.append('      EDITED $msig: $changes');
        addedOrChanged = true;
      }
      messagesById[msg.id] = msg;

      var widget = messageItemsById[msg.id];
      if (widget != null) {
        // no need to find widget in messageItems and re-insert a new instance
        widget.message = msg;
      }
    }

    return addedOrChanged;
  }

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

  MessageItem? _newPurchaseItem;
  MessageItem? get newPurchaseItem => _newPurchaseItem;
  set newPurchaseItem(MessageItem? val) {
    _newPurchaseItem = val;
    notifyListeners();
  }

  addEmptyPurchase(NewPurchaseSettings newPurchaseSettings) {
    final newPurchase = PurchaseDto(
      id: 0,
      date_created: DateTime.now(),
      date_updated: DateTime.now(),
      name: '',
      room: currentRoomId,
      message: 0,
      show_pgroup: newPurchaseSettings.showPgroups,
      show_price: newPurchaseSettings.showPrice,
      show_qnty: newPurchaseSettings.showQnty,
      show_weight: newPurchaseSettings.showWeight,
      copiedfrom_id: null,
      person_created: userId,
      person_created_name: userName,
      persons_can_edit: currentRoom.users.map((x) => x.id).toList(),
      purchased: false,
      person_purchased: null,
      person_purchased_name: null,
      price_total: null,
      weight_total: null,
      purItems: [PurItemDto(id: 0, bought: false, name: '')],
    );

    final newMessage = MessageDto(
      id: 0,
      date_created: DateTime.now(),
      date_updated: DateTime.now(),
      content: '',
      edited: false,
      replyto_id: null,
      forwardfrom_id: null,
      persons_sent: [],
      persons_read: [],
      room: currentRoomId,
      user: userId,
      user_name: userName,
      purchaseId: 0,
      purchase: newPurchase,
    );

    final widget = MessageItem(
      key: Key(newMessage.id.toString()),
      isMe: true,
      message: newMessage,
    );

    newPurchaseItem = widget;
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
