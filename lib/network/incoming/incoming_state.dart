import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';

import '../../utils/static_logger.dart';
import '../../views/chat/message_item.dart';
import '../connection.dart';
import '../outgoing/outgoing_handlers.dart';
import 'message_dto.dart';
import 'pur_item_dto.dart';
import 'purchase_dto.dart';
import 'room_dto.dart';
import 'user_dto.dart';

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

  final Map<int, MessageDto> messagesDtoUnreadById = <int, MessageDto>{};
  List<int> getOnlyUnreadMessages() {
    final List<MessageDto> all = messagesDtoUnreadById.values.toList();
    final List<MessageDto> unread =
        all.where((x) => !x.persons_read.contains(userId)).toList();
    final List<int> unreadMsgIds = unread.map((y) => y.id).toList();
    return unreadMsgIds;
  }

  final Map<int, MessageDto> messageDtoById = <int, MessageDto>{};
  final Map<int, MessageWidget> messageWidgetById = <int, MessageWidget>{};
  // Iterable<MessageItem> get msg.id.toString() => _messageWidgetsById.values;
  final List<MessageWidget> messageWidgets = [];
  List<MessageWidget> get getMessageWidgets => messageWidgets;

  bool messageAddOrEdit(MessageDto msg, String msig) {
    bool rebuildUi = false;

    final MessageDto? prevMsg = messageDtoById[msg.id];
    if (prevMsg == null) {
      final msgWidget = MessageWidget(
        key: Key(msg.id.toString()),
        isMe: isMyUserId(msg.user),
        message:
            msg, // don't msg.clone(): don't detach from messagesById[msg.id]
      );

      messageDtoById[msg.id] = msg;
      if (!msg.persons_read.contains(userId)) {
        messagesDtoUnreadById[msg.id] = msg;
      }

      messageWidgetById[msg.id] = msgWidget;
      messageWidgets.insert(0, msgWidget);

      rebuildUi = true;
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
              '\t\tbought:${x.bought}'
              '\t\tqnty:${x.qnty}'
              '\t\tpunit:${x.punit_name}(${x.punit_id})'
              '\t\tpgroup:${x.pgroup_name}(${x.pgroup_id})'
              '\t\tproduct:${x.product_name}(${x.product_id})';
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
        StaticLogger.append('      NOT_CHANGED(PURITEMS_EXCLUDED) $msig');
      } else {
        StaticLogger.append('      EDITED(PURITEMS_EXCLUDED) $msig: $changes');
        rebuildUi = true;
      }
      messageDtoById[msg.id] = msg;

      final widget = messageWidgetById[msg.id];
      if (widget != null) {
        //v1 hoping there is no need to find widget in messageWidgets and re-insert a new instance
        // widget.message = msg;
        //v2 after purItemFill() I receive the updated message => replace & force re-render (new key!!!)
        String forceReRenderAfterPurItemFill =
            dateFormatterHmsMillis.format(DateTime.now());
        String newKey = msg.id.toString() + '-' + forceReRenderAfterPurItemFill;
        final msgWidget = MessageWidget(
          key: Key(newKey),
          isMe: isMyUserId(msg.user),
          message:
              msg, // don't msg.clone(): don't detach from messagesById[msg.id]
        );
        messageWidgetById[msg.id] = msgWidget;

        // 1) after I edited a message, server sends new MessageDto
        // 2) new widget was created with new text => we replace unedited copy for chat.dart
        final indexFound =
            messageWidgets.indexWhere((x) => x.message.id == msg.id);
        if (indexFound >= 0) {
          messageWidgets[indexFound] = msgWidget;
          rebuildUi = true;
          StaticLogger.append(
              '         REPLACED with new msgWidget[key=$newKey] $msig');
        } else {
          StaticLogger.append('         NO_WIDGET_FOUND_FOR $msig');
        }
      } else {
        StaticLogger.append('         NO_WIDGET_FOUND_FOR $msig');
      }
    }

    return rebuildUi;
  }

  clearAllMessages() {
    messagesDtoUnreadById.clear();
    messageDtoById.clear();
    messageWidgetById.clear();
    messageWidgets.clear();
    notifyListeners();
  }

  String removeMessageFromMessagesUnreadById(int msgId) {
    var log = '';

    if (messagesDtoUnreadById.containsKey(msgId)) {
      messagesDtoUnreadById.remove(msgId);
      log += ' REMOVED from messagesUnreadById;';
    } else {
      log += ' NOT_FOUND_IN messagesUnreadById;';
    }

    return log;
  }

  String removeMessageFromAllMaps(int msgId) {
    var log = '';

    if (messageDtoById.containsKey(msgId)) {
      messageDtoById.remove(msgId);
      log += ' REMOVED from messagesById;';
    } else {
      log += ' NOT_FOUND_IN messagesById;';
    }

    if (messagesDtoUnreadById.containsKey(msgId)) {
      messagesDtoUnreadById.remove(msgId);
      log += ' REMOVED from messagesUnreadById;';
    } else {
      log += ' NOT_FOUND_IN messagesUnreadById;';
    }

    if (messageWidgetById.containsKey(msgId)) {
      messageWidgetById.remove(msgId);
      log += ' REMOVED from messageWidgetsById;';
    } else {
      log += ' NOT_FOUND_IN messageWidgetsById;';
    }

    final indexFound = messageWidgets.indexWhere((x) => x.message.id == msgId);
    if (indexFound >= 0) {
      messageWidgets.removeAt(indexFound);
      log += ' REMOVED from messageWidgets;';
    } else {
      log += ' NOT_FOUND_IN messageWidgets;';
    }
    return log;
  }

  MessageWidget? _newPurchaseMessageItem;
  MessageWidget? get newPurchaseMessageItem => _newPurchaseMessageItem;
  set newPurchaseMessageItem(MessageWidget? val) {
    _newPurchaseMessageItem = val;
    notifyListeners();
  }

  bool editingNewPurchase(MessageWidget mi) {
    return newPurchaseMessageItem != null && newPurchaseMessageItem == mi;
  }

  thisPurchaseIsNew(PurchaseDto purchaseDto) {
    return newPurchaseMessageItem?.message != null &&
        newPurchaseMessageItem!.message.purchase == purchaseDto;
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
      show_serno: newPurchaseSettings.showSerno,
      show_qnty: newPurchaseSettings.showQnty,
      show_price: newPurchaseSettings.showPrice,
      show_weight: newPurchaseSettings.showWeight,
      show_state_unknown: newPurchaseSettings.showStateUnknown,
      show_state_stop: newPurchaseSettings.showStateStop,
      replyto_id: null,
      copiedfrom_id: null,
      person_created: userId,
      person_created_name: userName,
      persons_can_edit: currentRoom.users.map((x) => x.id).toList(),
      persons_can_fill: currentRoom.users.map((x) => x.id).toList(),
      purchased: false,
      person_purchased: null,
      person_purchased_name: null,
      price_total: null,
      weight_total: null,
      purItems: [PurItemDto(id: 0, bought: 0, name: '')],
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

    final msgWidget = MessageWidget(
      key: Key(newMessage.id.toString()),
      isMe: true,
      message: newMessage,
    );

    newPurchaseMessageItem = msgWidget;
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

    messageDtoById.clear();
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
