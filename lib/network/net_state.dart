import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shopping_list_flutter/env/env.dart';
import 'package:shopping_list_flutter/widget/message_item.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/widgets.dart';

import 'objects/message.dart';
import 'objects/typing.dart';
import 'objects/user.dart';

class NetState extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Socket? _socket;
  Socket get socket => _socket!;
  String get socketId => _socket?.id ?? "SOCKET_NOT_YET_CONNECTED";
  String get sConnected => _socket == null
      ? "NO_CONNECTION_ATTEMPT"
      : _socket!.connected
          ? 'connected'
          : 'disconnected';

  set socket(Socket val) {
    _socket = val;
    notifyListeners();
  }

  String _typing = '';
  String get typing => _typing;
  set typing(String val) {
    _typing = val;
    notifyListeners();
  }

  User? _user;
  User get user => _user!;
  String get userName => _user?.name ?? "USER_OBJECT_NOT_YET_RECEIVED";
  set user(User val) {
    _user = val;
    notifyListeners();
  }

  List<MessageItem> _messages = [];
  List<MessageItem> get messages => _messages;
  set messages(List<MessageItem> val) {
    _messages = val;
    notifyListeners();
  }

  Timer? _debounce;
  Timer? get debounce => _debounce;
  set debounce(Timer? val) {
    _debounce = val;
    notifyListeners();
  }

  Env env;
  NetState(this.env);

  void connect() {
    final url = env.websocketURL;
    try {
      socket = io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();
      print('#1/3 connecting');

      socket.on('connect', (_) => {print('#2/3 connected: $socketId')});
      socket.on('typing', handleTyping);
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => {print('disconnect')});
      socket.on('fromServer', (_) => {print(_)});
      print('#3/3 handlers hooked to a socket [$sConnected]');
    } catch (e) {
      print(e.toString());
    }
  }

  sendTyping(bool typing) {
    if (_socket == null) {
      print('sendTyping(): $socketId');
      return;
    }
    socket.emit(
        "typing",
        Typing(
          id: socketId,
          username: userName,
          typing: typing,
        ).toJson());
  }

  void handleTyping(data) {
    final typingObj = Typing.fromJson(data);

    if (!isMySocketId(typingObj.id) && typingObj.typing) {
      typing = '${typingObj.username} is typing...';
    } else if (!isMySocketId(typingObj.id) && !typingObj.typing) {
      typing = '';
    }
  }

  TextEditingController msgInputCtrl = TextEditingController();
  bool get inputIsEmpty => msgInputCtrl.text.isEmpty;
  sendMessage() {
    if (inputIsEmpty) {
      return;
    }
    sendTyping(false);

    if (_socket == null) {
      showSnackBar('sendMessage(): $socketId', 10, () => {});
      return;
    }

    print('sending message a [' + sConnected + '] socket');

    final msg = Message(
      id: socketId,
      username: userName,
      message: msgInputCtrl.text,
      timestamp: DateTime.now(),
    ).toJson();
    socket.emit("message", msg);
    msgInputCtrl.clear();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void handleMessage(data) {
    try {
      var msg = Message.fromJson(data);
      if (!isMySocketId(msg.id)) {
        showToast('${msg.username}: ${msg.message}',
            context: scaffoldKey.currentContext,
            animation: StyledToastAnimation.slideFromTop,
            reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.bottom,
            startOffset: Offset(0.0, -3.0),
            reverseEndOffset: Offset(0.0, -3.0),
            duration: Duration(seconds: 4),
            //Animation duration   animDuration * 2 <= duration
            animDuration: Duration(seconds: 1),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
      }
      messages.insert(
        0,
        MessageItem(
          isMe: isMySocketId(msg.id),
          message: msg,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  bool isMySocketId(String id) => id == socket.id;
  void showSnackBar(String data, [int? time, Function? onTap]) {
    // ScaffoldMessenger.showSnackBar()
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: GestureDetector(
          child: Text(
            data,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // onTap: onTap,
        ),
        duration: Duration(seconds: time ?? 7),
      ));
    }
  }

  @override
  void dispose() {
    _socket?.disconnect();
    super.dispose();
  }
}
