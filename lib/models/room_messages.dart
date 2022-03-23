import 'package:flutter/widgets.dart';

import '../network/incoming/message/message_dto.dart';
import '../network/incoming/purchase/pur_item_dto.dart';
import '../utils/static_logger.dart';
import '../utils/theme.dart';
import '../views/chat/message_item.dart';

class RoomMessages {
  final Map<int, MessageDto> messagesDtoUnreadById = <int, MessageDto>{};
  bool filledInitially = false;

  int myPersonId;
  Function(String err) setClientError;
  RoomMessages({required this.myPersonId, required this.setClientError});

  List<int> getOnlyUnreadMessages() {
    final List<MessageDto> all = messagesDtoUnreadById.values.toList();
    final List<MessageDto> unread =
        all.where((x) => !x.persons_read.contains(myPersonId)).toList();
    final List<int> unreadMsgIds = unread.map((y) => y.id).toList();
    return unreadMsgIds;
  }

  final Map<int, MessageDto> messageDtoById = <int, MessageDto>{};
  final Map<int, MessageWidget> messageWidgetById = <int, MessageWidget>{};

  // Iterable<MessageItem> get msg.id.toString() => _messageWidgetsById.values;
  final List<MessageWidget> messageWidgets = [];

  List<MessageWidget> get getMessageWidgets => messageWidgets;

  bool messageAddOrEdit(
      MessageDto msgReceived, int isEditingMessageId, String msig) {
    bool rebuildUi = false;

    final MessageDto? prevMsg = messageDtoById[msgReceived.id];

    String forceReRenderAfterPurItemFill =
        dateFormatterHmsMillis.format(DateTime.now());
    String key =
        msgReceived.id.toString() + '-' + forceReRenderAfterPurItemFill;

    if (prevMsg == null) {
      final msgWidget = MessageWidget(
        key: Key(key),
        isMe: msgReceived.user == myPersonId,
        message:
            msgReceived, // don't msg.clone(): don't detach from messagesById[msg.id]
      );

      messageDtoById[msgReceived.id] = msgReceived;
      if (!msgReceived.persons_read.contains(myPersonId)) {
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
          setClientError(msg);
        } else {
          //v1 hoping there is no need to find widget in messageWidgets and re-insert a new instance
          // widget.message = msg;
          //v2 after purItemFill() I receive the updated message => replace & force re-render (new key!!!)
          final replacementMsgWidget = MessageWidget(
            key: Key(key),
            isMe: msgReceived.user == myPersonId,
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
}
