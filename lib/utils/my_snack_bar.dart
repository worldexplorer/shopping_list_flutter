import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network/incoming/incoming_state.dart';
import '../views/theme.dart';

void mySnackBar(
    BuildContext context,
    // GlobalKey messengerKey,
    String message,
    Function? clearMessage) {
  if (message == '') {
    return;
  }

  //https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final snackControl = ScaffoldMessenger.of(context);
    // final snackControl = messengerKey.currentState;

    snackControl.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: GestureDetector(
        child: Text(
          message,
          style: snackBarErrorTextStyle,
        ),
        onTap: () {
          snackControl.hideCurrentSnackBar();
          // snackControl.removeCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 20),
      // action: SnackBarAction(
      //   label: 'X',
      //   textColor: Colors.yellow,
      //   onPressed: () {
      //     snackControl.hideCurrentSnackBar();
      //   },
      //  )
    ));

    if (clearMessage != null) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        clearMessage();
      });
    }
  });
}

void buildSnackBar(BuildContext context, WidgetRef ref,
    {Function(String serverError)? clearServerErrorCallback,
    Function(String clientError)? clearClientErrorCallback}) {
  final serverError =
      ref.watch(incomingStateProvider.select((state) => state.serverError));

  final clearServerError = ref
      .watch(incomingStateProvider.select((state) => state.clearServerError));

  final clientError =
      ref.watch(incomingStateProvider.select((state) => state.clientError));

  final clearClientError = ref
      .watch(incomingStateProvider.select((state) => state.clearClientError));

  mySnackBar(context, serverError, () {
    clearServerError();
    clearServerErrorCallback?.call(serverError);
  });
  mySnackBar(context, clientError, () {
    clearClientError();
    clearClientErrorCallback?.call(clientError);
  });
}
