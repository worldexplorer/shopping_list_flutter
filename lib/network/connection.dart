import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../env/env.dart';
import '../../utils/static_logger.dart';
import 'connection_state.dart';
import 'incoming/incoming.dart';
import 'outgoing/outgoing_handlers.dart';

final connectionStateProvider =
    ChangeNotifierProvider.family<Connection, Env>((ref, env) {
  final conn = Connection(env);
  final incomingState = ref.read(incomingStateProvider);
  conn.lateBindCreateSocket(incomingState);
  return conn;
});

class Connection extends ChangeNotifier {
  final Env _env;

  late ConnectionState _connectionState;
  late IncomingState _incomingState;
  late OutgoingHandlers outgoingHandlers;
  late IncomingHandlers incomingHandlers;
  late Socket _socket;

  Connection(this._env) {
    _connectionState = ConnectionState();
  }

  void lateBindCreateSocket(IncomingState incomingState) {
    _incomingState = incomingState;
    _incomingState.connection = this;
    outgoingHandlers = OutgoingHandlers(_connectionState, _incomingState);
    _incomingState.outgoingHandlers = outgoingHandlers;
    incomingHandlers =
        IncomingHandlers(_connectionState, _incomingState, outgoingHandlers);
    createSocket();
  }

  void createSocket() {
    _socket = io(_env.websocketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      StaticLogger.append('#3/4 connected: [${_connectionState.socketId}]');
      // connectionNotifier.notify();
      if (_env.myAuthToken != null) {
        // outgoingHandlers.sendLogin(_env.myAuthToken!);
        outgoingHandlers.sendLogin(_env.myMobile);
      }
    });
    _socket.on('disconnect', (_) {
      StaticLogger.append(
          'disconnected by server; willGetMessagesOnReconnect=true');
      _connectionState.willGetMessagesOnReconnect = true;
    });
    _socket.on('fromServer', (_) => {StaticLogger.append(_)});

    _socket.on('user', incomingHandlers.onUser);
    _socket.on('rooms', incomingHandlers.onRooms);
    _socket.on('typing', incomingHandlers.onTyping);
    _socket.on('message', incomingHandlers.onMessage);
    _socket.on('updatedMessagesRead', incomingHandlers.onMessagesReadUpdated);
    _socket.on('archivedMessages', incomingHandlers.onArchivedMessages);
    _socket.on('deletedMessages', incomingHandlers.onDeletedMessages);
    _socket.on('messages', incomingHandlers.onMessages);
    _socket.on('error', incomingHandlers.onServerError);

    StaticLogger.append(
        '#1/4 handlers hooked to a socket [${_connectionState.sConnected}]');
  }

  void connect() async {
    try {
      _socket.connect();
      StaticLogger.append('#2/4 connecting to [${_env.websocketURL}]');
      _connectionState.socket = _socket;
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void disconnect() {
    try {
      _socket.connect();
      StaticLogger.append('#4/4 disconnected');
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void reconnect() {
    disconnect();
    _connectionState.willGetMessagesOnReconnect = true;
    connect();
    outgoingHandlers.sendLogin(_env.myMobile);
  }

  @override
  void dispose() {
    _socket.dispose();
  }
}
