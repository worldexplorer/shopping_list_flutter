import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../views/chat/message_item.dart';
import 'static_logger.dart';

final uiStateProvider = ChangeNotifierProvider<UiState>((ref) => UiState());

class UiState extends ChangeNotifier {
  late AnimationController? menuVisibleController;

  final msgInputCtrl = TextEditingController();
  int? isReplyingToMessageId;

  final messagesSelected = <int, MessageWidget>{};

  bool isSingleSelected(int messageId) {
    return messagesSelected.length == 1 &&
        messagesSelected.keys.toList()[0] == messageId;
  }

  void toMenuAndBack() {
    if (isMenuVisible) {
      menuVisibleController?.forward();
    } else {
      menuVisibleController?.reverse();
    }
    isMenuVisible = !isMenuVisible;
  }

  bool _isMenuVisible = true;
  bool get isMenuVisible => _isMenuVisible;
  set isMenuVisible(bool val) {
    _isMenuVisible = val;
    notifyListeners();
  }

  int _refreshCounter = 0;
  int get refreshCounter => _refreshCounter;
  void rebuild() {
    _refreshCounter++;
    notifyListeners();
    StaticLogger.append('UI.REBUILT[${_refreshCounter.toString()}]');
  }

  // TODO: save to local database
  final newPurchaseSettings = NewPurchaseSettings();
}

class NewPurchaseSettings {
  bool showPgroups = false;
  bool showSerno = false;
  bool showQnty = false;
  bool showPrice = false;
  bool showWeight = false;
  bool showStateUnknown = true;
  bool showStateStop = true;
}
