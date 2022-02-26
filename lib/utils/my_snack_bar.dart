import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

void mySnackBar(BuildContext context, String message, Function? clearMessage) {
  if (message == '') {
    return;
  }

  //https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
  SchedulerBinding.instance?.addPostFrameCallback((_) {
    final TextStyle snackBarErrorTextStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: GestureDetector(
        child: Text(
          message,
          style: snackBarErrorTextStyle,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // ScaffoldMessenger.of(context).removeCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 9999),
      // action: SnackBarAction(
      //   label: 'X',
      //   textColor: Colors.yellow,
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
