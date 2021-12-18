import 'package:flutter/material.dart';
// import 'package:shopping_list_flutter/network/net_log.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:shopping_list_flutter/env/env_loader.dart';

import 'connection_notifier.dart';
import 'incoming/incoming_notifier.dart';
import 'outgoing/outgoing_notifier.dart';

class Connection {
  Env env;
  late ConnectionNotifier connectionNotifier;
  late IncomingNotifier incomingNotifier;
  late OutgoingNotifier outgoingNotifier;

  Connection(this.env) {
    connectionNotifier = ConnectionNotifier();
    incomingNotifier = IncomingNotifier(connectionNotifier);
    outgoingNotifier = OutgoingNotifier(connectionNotifier, incomingNotifier);
  }

  void connect() {
    final url = env.websocketURL;
    try {
      final socket = io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();
      debugPrint('#1/3 connecting to [$url]');

      connectionNotifier.socket = socket;

      socket.on('connect', (_) {
        debugPrint('#2/3 connected: [${connectionNotifier.socketId}]');
        outgoingNotifier.sendLogin(env.phone);
      });
      socket.on('disconnect', (_) => {debugPrint('disconnected')});
      socket.on('fromServer', (_) => {debugPrint(_)});

      socket.on('user', incomingNotifier.onUser);
      socket.on('rooms', incomingNotifier.onRooms);
      socket.on('typing', incomingNotifier.onTyping);
      socket.on('message', incomingNotifier.onNewMessage);

      debugPrint(
          '#3/3 handlers hooked to a socket [${connectionNotifier.sConnected}]');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
