import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

ThemeData theme(BuildContext _) {
  return ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.manropeTextTheme(
      Theme.of(_).textTheme,
    ),
    primaryColor: const Color(0xff5B428F),
    selectedRowColor: const Color(0xdbead465),
    primaryColorDark: const Color(0xff262833),
    primaryColorLight: const Color(0xffFCF9F5),
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

Color get chatBackground =>
    Platform.isIOS ? const Color(0xff242f3e) : const Color(0xff17263c);
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

Color get menuBackgroundColor => const Color(0xFF4A4A58);

Color get altColor =>
    Platform.isIOS ? const Color(0xff17263c) : const Color(0xff28263c);

TextStyle purchaseStyle = const TextStyle(color: Colors.white);
TextStyle sernoStyle = TextStyle(
  color: Colors.white.withOpacity(0.4),
);

TextStyle pGroupStyle = const TextStyle(
    color: Color(0xD9E6FF8F), fontSize: 20, fontWeight: FontWeight.bold);
TextStyle totalsStyleGreen = const TextStyle(color: Colors.lightGreenAccent);
TextStyle totalsStyleGray = const TextStyle(color: Colors.white30);

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

const double editableInputIconSize = 24;
const double sendMessageInputIconSize = 24;

TextStyle logRecordStyle = const TextStyle(
  //GoogleFonts.poppins(
  color: Colors.white,
  fontSize: 13.0,
  // letterSpacing: 1,
  // wordSpacing: 1,
);

final dateFormatterHmsMillis = DateFormat('HH:mm:ss.SSS');

final loginButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.indigo,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15));

const loginButtonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const loginScreenTextStyle = TextStyle(
  fontSize: 20,
);

TextStyle appBarTextStyle(bool socketConnected) {
  return TextStyle(
    //GoogleFonts.manrope(
    color: whiteOrConnecting(socketConnected),
    fontWeight: FontWeight.w600,
    fontSize: 17,
  );
}

Color whiteOrConnecting(bool socketConnected) {
  return socketConnected ? Colors.white : Colors.amberAccent;
}

Text titleText(bool socketConnected, String text) {
  return Text(
    socketConnected ? text : "Connecting...",
    style: appBarTextStyle(socketConnected),
  );
}

TextStyle chatSliverSubtitleStyle([bool socketConnected = true]) {
  return TextStyle(
    // GoogleFonts.manrope(
    color: whiteOrConnecting(socketConnected).withOpacity(0.8),
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );
}

Text subtitleText(bool socketConnected, String text) {
  return Text(
    socketConnected ? text : "Connecting...",
    style: chatSliverSubtitleStyle(socketConnected),
  );
}

const unreadMessagesTextStyle = TextStyle(
  fontSize: 11,
);

final TextStyle ctxMenuItemTextStyle = TextStyle(
  // GoogleFonts.poppins(
  color: Colors.white.withOpacity(0.8),
  fontSize: 15,
);

const TextStyle snackBarErrorTextStyle = TextStyle(
  // GoogleFonts.poppins(
  color: Colors.white,
  fontSize: 20,
);

final TextStyle dismissibleTextStyle = TextStyle(
  // GoogleFonts.poppins(
  color: Colors.white.withOpacity(0.8),
  fontSize: 18,
);

final TextStyle snackBarDismissedTextStyle = TextStyle(
  // GoogleFonts.poppins(
  color: Colors.red.withOpacity(0.8),
  fontSize: 18,
);

TextStyle messageUserStyle(bool isMe) {
  return TextStyle(
      // GoogleFonts.manrope(
      color: isMe ? Colors.grey : Colors.green,
      fontSize: 15,
      fontWeight: FontWeight.bold);
}

TextStyle messageContentStyle(bool isMe) {
  return TextStyle(
    // GoogleFonts.poppins(
    color: Colors.white.withOpacity(isMe ? 1 : 0.8),
    fontSize: 15,
  );
}

TextStyle messageReadStatusStyle(bool isMe) {
  return TextStyle(
    //  GoogleFonts.poppins(
    color: Colors.grey.withOpacity(isMe ? 1 : 0.8),
    fontSize: 10,
  );
}

TextStyle messageEditedStyle(bool isMe) {
  return TextStyle(
      // GoogleFonts.poppins(
      color: Colors.yellowAccent.withOpacity(isMe ? 1 : 0.8),
      fontSize: 10,
      fontStyle: FontStyle.italic);
}

const TextStyle messageTimeAgoStyle = TextStyle(
    // GoogleFonts.manrope(
    color: Colors.grey,
    fontSize: 10,
    fontWeight: FontWeight.w300);

TextStyle purchaseNameStyle(bool isMe) {
  return TextStyle(
    // GoogleFonts.poppins(
    color: Colors.white.withOpacity(isMe ? 1 : 0.8),
    fontSize: 15,
  );
}

const loginTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle listItemTitleStyle =
    const TextStyle(color: Colors.white, fontSize: 20);

TextStyle listItemSubtitleStyle =
    TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14);
