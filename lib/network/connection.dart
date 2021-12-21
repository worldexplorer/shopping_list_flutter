import 'package:shopping_list_flutter/env/env.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
    incomingNotifier.outgoingNotifier = outgoingNotifier;
  }

  void connect() {
    final url = env.websocketURL;
    try {
      final socket = io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();
      StaticLogger.append('#1/3 connecting to [$url]');

      connectionNotifier.socket = socket; // notifies

      socket.on('connect', (_) {
        StaticLogger.append('#2/3 connected: [${connectionNotifier.socketId}]');
        // connectionNotifier.notify();
        outgoingNotifier.sendLogin(env.myMobile);
      });
      socket.on('disconnect', (_) => {StaticLogger.append('disconnected')});
      socket.on('fromServer', (_) => {StaticLogger.append(_)});

      socket.on('user', incomingNotifier.onUser);
      socket.on('rooms', incomingNotifier.onRooms);
      socket.on('typing', incomingNotifier.onTyping);
      socket.on('message', incomingNotifier.onMessage);
      socket.on('messages', incomingNotifier.onMessages);

      StaticLogger.append(
          '#3/3 handlers hooked to a socket [${connectionNotifier.sConnected}]');
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }
}
