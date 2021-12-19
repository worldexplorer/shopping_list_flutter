import 'dart:async';
import 'package:flutter/material.dart';

class UiNotifier extends ChangeNotifier {
  Timer? _debounce;
  Timer? get debounce => _debounce;
  set debounce(Timer? val) {
    _debounce = val;
    notifyListeners();
  }
}
