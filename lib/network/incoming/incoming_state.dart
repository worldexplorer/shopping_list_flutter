import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';

import '../../models/rooms.dart';
import '../../views/room/message_widget.dart';
import '../connection.dart';
import '../outgoing/outgoing_handlers.dart';
import 'message/message_dto.dart';
import 'person/person_dto.dart';
import 'person/registration_needs_code_dto.dart';
import 'purchase/pur_item_dto.dart';
import 'purchase/purchase_dto.dart';

final incomingStateProvider =
    ChangeNotifierProvider<IncomingState>((ref) => IncomingState());

class IncomingState extends ChangeNotifier {
  late OutgoingHandlers outgoingHandlers;
  late Connection connection;

  bool get socketConnected {
    return connection != null
        ? connection.connectionState.socketConnected
        : false;
  }

  String? _auth;
  String? get auth => _auth;
  set auth(String? val) {
    _auth = val;
    notifyListeners();
  }

  bool waitingForLoginResponse = false;

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

  static const PERSON_DTO_NOT_RECEIVED = "PERSON_DTO_NOT_RECEIVED";
  PersonDto? _person;
  PersonDto? get personNullable => _person;
  PersonDto get personReceived => _person!;
  int get personId => _person?.id ?? -1;
  String get personName => _person?.name ?? PERSON_DTO_NOT_RECEIVED;
  set personReceived(PersonDto personLoggedIn) {
    bool firstTimeLogin = _person == null;
    bool differentPersonLoggedIn =
        _person != null && _person!.id != personLoggedIn.id;

    if (firstTimeLogin || differentPersonLoggedIn) {
      rooms = Rooms(
          outgoingHandlers: outgoingHandlers,
          myPersonId: personLoggedIn.id,
          setClientError: (String msg) {
            clientError = msg;
          });
    }
    _person = personLoggedIn;
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

  MessageWidget? _newPurchaseMessageWidget;

  MessageWidget? get newPurchaseMessageItem => _newPurchaseMessageWidget;

  set newPurchaseMessageItem(MessageWidget? val) {
    _newPurchaseMessageWidget = val;
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
      room: rooms.currentRoomId,
      message: 0,
      show_pgroup: newPurchaseSettings.showPgroups,
      show_serno: newPurchaseSettings.showSerno,
      show_qnty: newPurchaseSettings.showQnty,
      show_price: newPurchaseSettings.showPrice,
      show_weight: newPurchaseSettings.showWeight,
      show_state_unknown: newPurchaseSettings.showStateUnknown,
      show_state_stop: newPurchaseSettings.showStateStop,
      show_state_halfdone: newPurchaseSettings.showStateHalfDone,
      show_state_question: newPurchaseSettings.showStateQuestion,
      replyto_id: null,
      copiedfrom_id: null,
      person_created: personId,
      person_created_name: personName,
      persons_can_edit:
          rooms.currentRoomUsersOrEmpty.map((x) => x.person).toList(),
      persons_can_fill:
          rooms.currentRoomUsersOrEmpty.map((x) => x.person).toList(),
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
      room: rooms.currentRoomId,
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

  late Rooms rooms;
  // final rooms = Rooms(
  //     backend: outgoingHandlers,
  //     myPersonId: personId,
  //     setClientError: (String msg) {clientError=msg});
  // int get currentRoomId => rooms.currentRoomId;
  set currentRoomId(int newRoomId) {
    if (rooms.currentRoomId == newRoomId) {
      return;
    }
    final shouldRequestBackend = rooms.setCurrentRoomId(newRoomId);
    if (shouldRequestBackend) {
      if (!rooms.currentRoomMessages.filledInitially) {
        outgoingHandlers.sendGetMessages(rooms.currentRoomId, 0);
      }
      // when notifyListeners() happens inside build(), throws:
      //    setState() or markNeedsBuild() called during build.
      //    This UncontrolledProviderScope widget cannot be marked as needing to build b
      // notifyListeners();
    }
  }

  void clearAllMessagesInCurrentRoom({bool notify = true}) {
    rooms.currentRoomMessages.clearAllMessages();
    if (notify) {
      notifyListeners();
    }
  }

  bool waitingForPersonsFound = false;
  // bool get waitingForPersonsFound => _waitingForPersonsFound;
  // set waitingForPersonsFound(bool val) {
  //   _waitingForPersonsFound = val;
  //   notifyListeners();
  // }

  List<PersonDto>? _personsFound;
  List<PersonDto>? get personsFound {
    return _personsFound;
  }

  set personsFound(List<PersonDto>? val) {
    _personsFound = val;
    notifyListeners();
  }
}
