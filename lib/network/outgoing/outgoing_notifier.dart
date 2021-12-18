import 'package:flutter/material.dart';
import 'package:shopping_list_flutter/network/dto/messages.dart';
import 'package:shopping_list_flutter/network/dto/typing.dart';
import 'package:shopping_list_flutter/network/incoming/incoming_notifier.dart';

import '../connection_notifier.dart';
import '../net_log.dart';
import 'login.dart';

class OutgoingNotifier extends ChangeNotifier {
  ConnectionNotifier connectionNotifier;
  IncomingNotifier incomingNotifier;

  OutgoingNotifier(this.connectionNotifier, this.incomingNotifier);

  sendLogin(String phone) {
    if (!connectionNotifier.socketConnected) {
      debugPrint('sendLogin($phone): ${connectionNotifier.socketId}');
      return;
    }
    final login = Login(
      phone: phone,
    ).toJson();
    connectionNotifier.socket.emit("login", login);
    debugPrint('    >> LOGIN [$login]');
  }

  sendTyping(bool typing) {
    if (!connectionNotifier.socketConnected) {
      // debugPrint('sendTyping($typing): ${connectionNotifier.socketId}');
      return;
    }
    connectionNotifier.socket.emit(
        "typing",
        Typing(
          socketId: connectionNotifier.socketId,
          userName: incomingNotifier.userName,
          typing: typing,
        ).toJson());
  }

  TextEditingController msgInputCtrl = TextEditingController();
  bool get inputIsEmpty => msgInputCtrl.text.isEmpty;
  sendMessage() {
    if (inputIsEmpty) {
      return;
    }
    final msg = msgInputCtrl.text;

    sendTyping(false);

    if (!connectionNotifier.socketConnected) {
      NetLog.showSnackBar(
          'sendMessage($msg): ${connectionNotifier.socketId}', 10, () => {});
      return;
    }

    final message = Message(
      socketId: connectionNotifier.socketId,
      userId: incomingNotifier.userId,
      username: incomingNotifier.userName,
      message: msg,
      timestamp: DateTime.now(),
    ).toJson();
    connectionNotifier.socket.emit("message", message);
    debugPrint('   >> MESSAGE [$message]');
    msgInputCtrl.clear();
  }
}
