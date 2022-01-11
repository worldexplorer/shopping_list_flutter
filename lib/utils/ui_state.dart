import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../views/chat/message_item.dart';

final uiStateProvider = ChangeNotifierProvider((ref) => UiState());

class UiState extends ChangeNotifier {
  late AnimationController? menuVisibleController;

  final msgInputCtrl = TextEditingController();
  int isEditingMessageId = 0;
  int? isReplyingToMessageId;

  final messagesSelected = <int, MessageItem>{};

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
  }

  // TODO: save to local database
  final newPurchaseSettings = NewPurchaseSettings();
}

class NewPurchaseSettings {
  bool showPgroups = true;
  bool showSerno = true;
  bool showQnty = false;
  bool showPrice = true;
  bool showWeight = false;
}
