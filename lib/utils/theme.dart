import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme(BuildContext _) {
  return ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.manropeTextTheme(
      Theme.of(_).textTheme,
    ),
    primaryColor: Color(0xff5B428F),
    selectedRowColor: Color(0xdbead465),
    primaryColorDark: Color(0xff262833),
    primaryColorLight: Color(0xffFCF9F5),
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

Color get chatBackground =>
    Platform.isIOS ? Color(0xff242f3e) : Color(0xff17263c);
Color get chatMessageSelected => Color.fromRGBO(
      Colors.yellow.red,
      Colors.yellow.green,
      Colors.yellow.blue,
      0.1,
    );
Color get chatMessageDismiss => Color.fromRGBO(
      Colors.red.red,
      Colors.red.green,
      Colors.red.blue,
      0.5,
    );
Color get chatMessageReply => Color.fromRGBO(
      Colors.green.red,
      Colors.green.green,
      Colors.green.blue,
      0.5,
    );

Color get menuBackgroundColor => Color(0xFF4A4A58);

Color get altColor => Platform.isIOS ? Color(0xff17263c) : Color(0xff28263c);

TextStyle purchaseStyle = const TextStyle(color: Colors.white);
TextStyle sernoStyle = TextStyle(
  color: Colors.white.withOpacity(0.4),
);

TextStyle pGroupStyle = const TextStyle(
    color: Color(0xD9E6FF8F), fontSize: 20, fontWeight: FontWeight.bold);
TextStyle totalsStyle = const TextStyle(color: Colors.lightGreenAccent);

TextStyle textInputStyle = const TextStyle(color: Colors.white);

TextStyle textInputHintStyle = TextStyle(
  color: Colors.white.withOpacity(0.6),
);

BoxDecoration textInputDecoration = BoxDecoration(
  color: altColor,
  borderRadius: BorderRadius.circular(6),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
    )
  ],
);

EdgeInsets textInputMargin = const EdgeInsets.fromLTRB(10, 0, 10, 5);
EdgeInsets textInputPadding = const EdgeInsets.fromLTRB(
  10.0,
  0,
  10.0,
  0,
);

const double qntyColumnWidth = 55;
const double priceColumnWidth = 80;
const double weightColumnWidth = 75;

const double iconSize = 24;
