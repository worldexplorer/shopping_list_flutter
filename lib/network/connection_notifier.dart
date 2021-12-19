import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ConnectionNotifier extends ChangeNotifier {
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
  bool get socketConnected => socketCreated && socket.connected;
  Socket get socket => _socket!;
  String get socketId => _socket?.id ?? "SOCKET_NOT_YET_CONNECTED";
  String get sConnected => socketCreated
      ? "NO_CONNECTION_ATTEMPT"
      : socket.connected
          ? 'connected'
          : 'disconnected';
  set socket(Socket val) {
    _socket = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket?.disconnect();
    super.dispose();
  }
}
