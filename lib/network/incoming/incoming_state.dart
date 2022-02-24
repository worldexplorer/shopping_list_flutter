import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';

import '../../utils/static_logger.dart';
import '../../views/chat/message_item.dart';
import '../connection.dart';
import '../outgoing/outgoing_handlers.dart';
import 'message/message_dto.dart';
import 'person/person_dto.dart';
import 'person/registration_needs_code_dto.dart';
import 'purchase/pur_item_dto.dart';
import 'purchase/purchase_dto.dart';
import 'room/room_dto.dart';

final incomingStateProvider =
    ChangeNotifierProvider<IncomingState>((ref) => IncomingState());

class IncomingState extends ChangeNotifier {
  late OutgoingHandlers outgoingHandlers;
  late Connection connection;

  String? _auth;
  String? get auth => _auth;
  set auth(String? val) {
    _auth = val;
    notifyListeners();
  }

  RegistrationNeedsCodeDto? _needsCode;
  RegistrationNeedsCodeDto? get needsCode => _needsCode;
  set needsCode(RegistrationNeedsCodeDto? val) {
    _needsCode = val;
    notifyListeners();
  }

  String get sentTo_fromServerResponse {
    String ret = '';
    if (needsCode != null) {
      if (needsCode!.emailSent) {
        ret += 'Email';
      }
      if (needsCode!.smsSent) {
        if (ret.isNotEmpty) {
          ret += ' and ';
        }
        ret += 'SMS';
      }
    }
    return ret;
  }

  PersonDto? _person;
  PersonDto get person => _person!;
  int get personId => _person?.id ?? -1;
  bool isMyUserId(int id) => id == personId;
  String get personName => _person?.name ?? "PERSON_DTO_NOT_YET_RECEIVED";
  set person(PersonDto val) {
    _person = val;
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

  clearServerError() {
    serverError = '';
  }

  String _clientError = '';
  String get clientError => _clientError;
  set clientError(String val) {
    _clientError = val;
    notifyListeners();
  }

  clearClientError() {
    clientError = '';
  }

  final Map<int, MessageDto> messagesDtoUnreadById = <int, MessageDto>{};

  List<int> getOnlyUnreadMessages() {
    final List<MessageDto> all = messagesDtoUnreadById.values.toList();
    final List<MessageDto> unread =
        all.where((x) => !x.persons_read.contains(personId)).toList();
    final List<int> unreadMsgIds = unread.map((y) => y.id).toList();
    return unreadMsgIds;
  }

  final Map<int, MessageDto> messageDtoById = <int, MessageDto>{};
  final Map<int, MessageWidget> messageWidgetById = <int, MessageWidget>{};

  // Iterable<MessageItem> get msg.id.toString() => _messageWidgetsById.values;
  final List<MessageWidget> messageWidgets = [];

  List<MessageWidget> get getMessageWidgets => messageWidgets;
  int isEditingMessageId = 0;

  bool messageAddOrEdit(MessageDto msgReceived, String msig) {
    bool rebuildUi = false;

    final MessageDto? prevMsg = messageDtoById[msgReceived.id];

    String forceReRenderAfterPurItemFill =
        dateFormatterHmsMillis.format(DateTime.now());
    String key =
        msgReceived.id.toString() + '-' + forceReRenderAfterPurItemFill;

    if (prevMsg == null) {
      final msgWidget = MessageWidget(
        key: Key(key),
        isMe: isMyUserId(msgReceived.user),
        message:
            msgReceived, // don't msg.clone(): don't detach from messagesById[msg.id]
      );

      messageDtoById[msgReceived.id] = msgReceived;
      if (!msgReceived.persons_read.contains(personId)) {
        messagesDtoUnreadById[msgReceived.id] = msgReceived;
      }

      messageWidgetById[msgReceived.id] = msgWidget;
      messageWidgets.insert(0, msgWidget);

      rebuildUi = true;
      StaticLogger.append('      ADDED $msig');

      var purchase = '';
      if (msgReceived.purchase != null) {
        final pur = msgReceived.purchase!;
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
      if (prevMsg.content != msgReceived.content) {
        changes += '[${prevMsg.content}]=>[${msgReceived.content}] ';
      }
      if (prevMsg.edited != msgReceived.edited) {
        changes += 'edited[${msgReceived.edited}] ';
      }
      if (prevMsg.purchase?.name != msgReceived.purchase?.name) {
        String prevPurchase = prevMsg.purchase?.name ?? 'NONE';
        String purchase = msgReceived.purchase?.name ?? 'NONE';
        changes += 'purchase[$prevPurchase]=>[$purchase] ';
      }
      if (prevMsg.purchase?.date_updated !=
          msgReceived.purchase?.date_updated) {
        DateTime? prevPurchase = prevMsg.purchase?.date_updated;
        DateTime? purchase = msgReceived.purchase?.date_updated;
        changes += 'purchase.date_updated[$prevPurchase]=>[$purchase] ';
      }
      if (changes == '') {
        StaticLogger.append('      NOT_CHANGED(PURITEMS_EXCLUDED) $msig');
      } else {
        StaticLogger.append('      EDITED(PURITEMS_EXCLUDED) $msig: $changes');
        rebuildUi = true;
      }
      messageDtoById[msgReceived.id] = msgReceived;

      final widget = messageWidgetById[msgReceived.id];
      if (widget != null) {
        if (msgReceived.id == isEditingMessageId) {
          final id = isEditingMessageId.toString();
          final msg = 'REJECTED server update EditingMessageId[$id]';
          StaticLogger.append(msg);
          clientError = msg;
        } else {
          //v1 hoping there is no need to find widget in messageWidgets and re-insert a new instance
          // widget.message = msg;
          //v2 after purItemFill() I receive the updated message => replace & force re-render (new key!!!)
          final replacementMsgWidget = MessageWidget(
            key: Key(key),
            isMe: isMyUserId(msgReceived.user),
            message:
                msgReceived, // don't msg.clone(): don't detach from messagesById[msg.id]
          );
          messageWidgetById[msgReceived.id] = replacementMsgWidget;

          // 1) after I edited a message, server sends new MessageDto
          // 2) new widget was created with new text => we replace unedited copy for chat.dart
          final indexFound =
              messageWidgets.indexWhere((x) => x.message.id == msgReceived.id);
          if (indexFound >= 0) {
            messageWidgets[indexFound] = replacementMsgWidget;
            rebuildUi = true;
            final what = 'newMsgWidget[key=$key]';
            StaticLogger.append('         REPLACED $what $msig');
          } else {
            StaticLogger.append('         NO_messageWidget_FOUND $msig');
          }
        }
      } else {
        final where =
            'NO_messageWidget_FOUND messageWidgetById[${msgReceived.id}]';
        StaticLogger.append('         LOOKUP_MAP_UNSYNC: $where $msig');
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
      person_created: personId,
      person_created_name: personName,
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
      user: personId,
      user_name: personName,
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
