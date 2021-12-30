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

Color get altColor => Platform.isIOS ? Color(0xff17263c) : Color(0xff28263c);
