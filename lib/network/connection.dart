import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../env/env.dart';
import '../../utils/static_logger.dart';
import 'connection_state.dart';
import 'incoming/incoming_handlers.dart';
import 'incoming/incoming_state.dart';
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

  late ConnectionState connectionState;
  late IncomingState _incomingState;
  late OutgoingHandlers outgoingHandlers;
  late IncomingHandlers incomingHandlers;
  late Socket _socket;

  Connection(this._env) {
    connectionState = ConnectionState();
  }

  void lateBindCreateSocket(IncomingState incomingState) {
    _incomingState = incomingState;
    _incomingState.connection = this;
    outgoingHandlers = OutgoingHandlers(connectionState, _incomingState);
    _incomingState.outgoingHandlers = outgoingHandlers;
    incomingHandlers =
        IncomingHandlers(connectionState, _incomingState, outgoingHandlers);
    createSocket();
  }

  void createSocket() {
    _socket = io(_env.websocketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      if (_env.myAuthToken != null) {
        StaticLogger.append('#3/4 connected: [${connectionState.socketId}]');
        outgoingHandlers.sendLogin(
            _env.myAuthToken!, 'createSocket()/onConnected');
      } else {
        StaticLogger.append(
            '#3/4 WILL_NOT_LOGIN(myAuthToken=null) connected: [${connectionState.socketId}]');
        _incomingState.notifyListeners(); // rebuild to show Login()
      }
    });

    _socket.on('disconnect', (_) {
      if (manuallyDisconnecting) {
        StaticLogger.append('disconnected manually');
        manuallyDisconnecting = false;
      } else {
        StaticLogger.append('disconnected by server; ENDLESS_LOGIN_LOOP?');
        connectionState.willGetMessagesOnReconnect = true;
        // connect();
        reconnect();
      }
    });
    _socket.on('fromServer', (_) => {StaticLogger.append(_)});

    _socket.on(
        'registrationNeedsCode', incomingHandlers.onRegistrationNeedsCode);
    _socket.on(
        'registrationConfirmed', incomingHandlers.onRegistrationConfirmed);
    _socket.on('person', incomingHandlers.onPerson);
    _socket.on('rooms', incomingHandlers.onRooms);
    _socket.on('room', incomingHandlers.onRoom);
    _socket.on('typing', incomingHandlers.onTyping);
    _socket.on('message', incomingHandlers.onMessage);
    _socket.on('updatedMessagesRead', incomingHandlers.onMessagesReadUpdated);
    _socket.on('archivedMessages', incomingHandlers.onArchivedMessages);
    _socket.on('deletedMessages', incomingHandlers.onDeletedMessages);
    _socket.on('messages', incomingHandlers.onMessages);
    _socket.on('error', incomingHandlers.onServerError);
    _socket.on('purItemFilled', incomingHandlers.onPurItemFilled);
    _socket.on('personsFound', incomingHandlers.onPersonsFound);

    StaticLogger.append(
        '#1/4 handlers hooked to a socket [${connectionState.sConnected}]');
  }

  void connect() {
    if (_socket.connected) {
      StaticLogger.append(
          '#2/4 ALREADY_CONNECTED: NOT connecting to [${_env.websocketURL}]');
      return;
    }

    try {
      _socket.connect();
      StaticLogger.append('#2/4 connecting to [${_env.websocketURL}]');
      connectionState.socket = _socket;
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  bool manuallyDisconnecting = false;

  void disconnect() {
    if (_socket.disconnected) {
      StaticLogger.append('#4/4 ALREADY_DISCONNECTED: NOT disconnecting');
      return;
    }

    try {
      manuallyDisconnecting = true;
      _socket.disconnect();
      StaticLogger.append('#4/4 disconnected manually');
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void reconnect() {
    disconnect();
    connectionState.willGetMessagesOnReconnect = true;
    dispose();
    createSocket();
    connect();
    // if (_env.myAuthToken != null) {
    //   outgoingHandlers.sendLogin(_env.myAuthToken!, 'reconnect');
    // }
  }

  @override
  void dispose() {
    _socket.dispose();
  }
}
