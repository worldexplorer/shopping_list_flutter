import 'package:shopping_list_flutter/env/env.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'connection_notifier.dart';
import 'incoming/incoming_notifier.dart';
import 'outgoing/outgoing.dart';

class Connection {
  Env env;
  late ConnectionNotifier connectionNotifier;
  late IncomingNotifier incomingNotifier;
  late Outgoing outgoingNotifier;
  late Socket socket;

  Connection(this.env) {
    connectionNotifier = ConnectionNotifier();
    incomingNotifier = IncomingNotifier(connectionNotifier);
    outgoingNotifier = Outgoing(connectionNotifier, incomingNotifier);
    incomingNotifier.outgoingNotifier = outgoingNotifier;

    socket = io(env.websocketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      StaticLogger.append('#3/4 connected: [${connectionNotifier.socketId}]');
      // connectionNotifier.notify();
      outgoingNotifier.sendLogin(env.myMobile);
    });
    socket.on('disconnect', (_) {
      StaticLogger.append(
          'disconnected by server; willGetMessagesOnReconnect=true');
      connectionNotifier.willGetMessagesOnReconnect = true;
    });
    socket.on('fromServer', (_) => {StaticLogger.append(_)});

    socket.on('user', incomingNotifier.onUser);
    socket.on('rooms', incomingNotifier.onRooms);
    socket.on('typing', incomingNotifier.onTyping);
    socket.on('message', incomingNotifier.onMessage);
    socket.on('updatedMessageRead', incomingNotifier.onUpdateMessageRead);
    socket.on('messages', incomingNotifier.onMessages);
    socket.on('error', incomingNotifier.onServerError);

    StaticLogger.append(
        '#1/4 handlers hooked to a socket [${connectionNotifier.sConnected}]');
  }

  void connect() {
    try {
      socket.connect();
      StaticLogger.append('#2/4 connecting to [${env.websocketURL}]');
      connectionNotifier.socket = socket; // notifies
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void disconnect() {
    try {
      socket.connect();
      StaticLogger.append('#4/4 disconnected');
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void reconnect() {
    disconnect();
    connect();
  }

  void dispose() {
    socket.dispose();
  }
}
