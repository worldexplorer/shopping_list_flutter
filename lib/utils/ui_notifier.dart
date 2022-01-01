import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/views/chat/message_item.dart';

final uiStateProvider = ChangeNotifierProvider((ref) => UiState());

class UiState extends ChangeNotifier {
  late AnimationController? menuVisibleController;

  final msgInputCtrl = TextEditingController();
  int isEditingMessageId = 0;
  int? isReplyingToMessageId;

  final messagesSelected = <int, MessageItem>{};

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
}
