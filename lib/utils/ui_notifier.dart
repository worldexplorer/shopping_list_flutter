import 'package:flutter/material.dart';

class UiNotifier extends ChangeNotifier {
  bool _isCollapsed = true;
  bool get isCollapsed => _isCollapsed;
  set isCollapsed(bool val) {
    _isCollapsed = val;
    notifyListeners();
  }

  AnimationController? _collapseController;
  AnimationController? get collapseController => _collapseController;
  set collapseController(AnimationController? val) {
    _collapseController = val;
    notifyListeners();
  }
}
