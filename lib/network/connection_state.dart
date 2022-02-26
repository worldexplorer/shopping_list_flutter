// import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ConnectionState
// extends ChangeNotifier
{
  // bool _receiving = false;
  // bool get receiving => _receiving;
  // set receiving(bool val) {
  //   _receiving = val;
  //   notifyListeners();
  // }

  // bool _sending = false;
  // bool get sending => _sending;
  // set sending(bool val) {
  //   _sending = val;
  //   notifyListeners();
  // }

  Socket? _socket;
  bool get socketCreated => _socket == null || socket.connected;
  bool get socketConnected => _socket != null && _socket!.connected;
  Socket get socket {
    if (_socket != null) {
      return _socket!;
    } else {
      throw "YOU_SHOULD_WAIT_FOR_CONNECTION";
    }
  }

  String get socketId => _socket?.id ?? "SOCKET_NOT_CONNECTED";
  String get sConnected => socketCreated
      ? "NO_CONNECTION_ATTEMPT"
      : socket.connected
          ? 'connected'
          : 'disconnected';
  set socket(Socket val) {
    _socket = val;
    // notifyListeners();
  }

  bool willGetMessagesOnReconnect = false;

  @override
  void dispose() {
    _socket?.disconnect();
    // super.dispose();
  }
}
