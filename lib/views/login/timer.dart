import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final timerStateProvider =
    ChangeNotifierProvider<TimerState>((ref) => TimerState());

class TimerState extends ChangeNotifier {
  Timer? _timer;
  bool get isRunning {
    return _timer != null ? _timer!.isActive : false;
  }

  String timeLeftFormatted = '';
  int secondsScheduled = 0;
  int secondsLeft = 0;

  bool get isOnLastSecond {
    return secondsLeft == 1;
  }

  void startTimer(
      {int start = 120,
      int decrementSec = 1,
      Function? onExpired,
      Function(int currentSecondsLeft)? onEachSecond}) {
    secondsScheduled = start;
    secondsLeft = start;
    timeLeftFormatted = formatSeconds(secondsLeft);
    _timer = Timer.periodic(Duration(seconds: decrementSec), (Timer timer) {
      secondsLeft = secondsLeft - decrementSec;
      if (secondsLeft > 0) {
        timeLeftFormatted = formatSeconds(secondsLeft);
      } else {
        timer.cancel();
        _timer = null;
        timeLeftFormatted = '';
        if (onExpired != null) {
          onExpired();
        }
      }
      if (onEachSecond != null) {
        onEachSecond(secondsLeft);
      }
      notifyListeners();
    });
  }

  formatSeconds(int seconds) {
    // https://flutterigniter.com/how-to-format-duration/
    // format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    // final d1 = Duration(seconds: seconds);
    // final formatted = format(d1)..substring(4, 7);
    // return formatted;

    final minutes = (secondsLeft / 60).floor();
    final seconds = secondsLeft % 60;
    return '$minutes'.padLeft(2, "0") + ':' + '$seconds'.padLeft(2, "0");

    // return '$secondsLeft sec';
  }
}
