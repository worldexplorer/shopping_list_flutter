import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

void mySnackBar(
    BuildContext context,
    // GlobalKey messengerKey,
    String message,
    Function? clearMessage) {
  if (message == '') {
    return;
  }

  //https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
  SchedulerBinding.instance?.addPostFrameCallback((_) {
    final TextStyle snackBarErrorTextStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
    );

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
