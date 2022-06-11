import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../env/env.dart';
import '../../utils/static_logger.dart';
import '../notifications/notifications_plugin.dart';
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

bool autoconnect = true;

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
      'autoConnect': autoconnect,
    });

    _socket.on('connect', (_) {
      if (_env.myAuthToken != null) {
        logNetStatus('#3/5 connected: [${connectionState.socketId}]');
        outgoingHandlers.sendLogin(
            _env.myAuthToken!, 'createSocket()/onConnected');
      } else {
        logNetStatus(
            '#3/5 WILL_NOT_LOGIN(myAuthToken=null) connected: [${connectionState.socketId}]');
        _incomingState.notifyListeners(); // rebuild to show Login()
      }
    });

    _socket.on('disconnect', (_) {
      if (manuallyDisconnecting) {
        logNetStatus('disconnected manually');
        manuallyDisconnecting = false;
      } else {
        logNetStatus('disconnected by server => reconnect()');
        connectionState.willGetMessagesOnReconnect = true;
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

    logNetStatus(
        '#1/5 handlers hooked to a new socket [${connectionState.sConnected}]' +
            ' autoconnect=' +
            (autoconnect ? 'true' : 'false'));
  }

  void connect([bool forceConnect = false]) {
    if (_socket.connected) {
      logNetStatus(
          '#2/5 ALREADY_CONNECTED: NOT connecting to [${_env.websocketURL}]');
      return;
    }

    if (autoconnect == false || forceConnect) {
      try {
        logNetStatus('#2/5 connecting to [${_env.websocketURL}]');
        _socket.connect();
      } catch (e) {
        StaticLogger.append(e.toString());
      }
    } else {
      logNetStatus(
          '#2/5 skip connecting to [${_env.websocketURL}] due to autoconnect=true');
    }
    connectionState.socket = _socket;
  }

  bool manuallyDisconnecting = false;

  void disconnect() {
    if (_socket.disconnected) {
      logNetStatus('#4/5 ALREADY_DISCONNECTED: NOT disconnecting');
      return;
    }

    try {
      manuallyDisconnecting = true;
      _socket.disconnect();
      logNetStatus('#4/5 disconnected manually');
    } catch (e) {
      StaticLogger.append(e.toString());
    }
  }

  void reconnect() {
    disconnect();
    connectionState.willGetMessagesOnReconnect = true;
    dispose();
    createSocket();
    connect(true);
    // if (_env.myAuthToken != null) {
    //   outgoingHandlers.sendLogin(_env.myAuthToken!, 'reconnect');
    // }
  }

  @override
  void dispose() {
    _socket.dispose();
    logNetStatus('#5/5 socket disposed');
  }

  void logNetStatus(String netStatus) {
    StaticLogger.append(netStatus);
    NotificationsPlugin.instance.notificator.showNetworkStatus(netStatus);
  }
}
