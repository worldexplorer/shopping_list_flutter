import 'dart:async';
import 'package:flutter/material.dart';

class UiNotifier extends ChangeNotifier {
  Timer? _debounce;
  Timer? get debounce => _debounce;
  set debounce(Timer? val) {
    _debounce = val;
    notifyListeners();
  }

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
