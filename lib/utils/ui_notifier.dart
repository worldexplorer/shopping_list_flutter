import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final uiStateProvider = ChangeNotifierProvider((ref) => UiState());

class UiState extends ChangeNotifier {
  late AnimationController? menuVisibleController;

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
  void incrementRefreshCounter() {
    _refreshCounter++;
    notifyListeners();
  }
}
