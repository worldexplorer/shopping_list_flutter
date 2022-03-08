class Popup {
  // static popupToast(String msg) {
  //   final scaffoldKey = GlobalKey<ScaffoldState>();
  //   showToast(msg,
  //       context: scaffoldKey.currentContext,
  //       animation: StyledToastAnimation.slideFromTop,
  //       reverseAnimation: StyledToastAnimation.slideToTop,
  //       position: StyledToastPosition.bottom,
  //       startOffset: Offset(0.0, -3.0),
  //       reverseEndOffset: Offset(0.0, -3.0),
  //       duration: Duration(seconds: 4),
  //       //Animation duration   animDuration * 2 <= duration
  //       animDuration: Duration(seconds: 1),
  //       curve: Curves.elasticOut,
  //       reverseCurve: Curves.fastOutSlowIn);
  // }

  // static void showSnackBar(String data, [int? time, Function? onTap]) {
  //   final scaffoldKey = GlobalKey<ScaffoldState>();
  //   // ScaffoldMessenger.showSnackBar()
  //   if (scaffoldKey.currentState != null) {
  //     scaffoldKey.currentState!.showSnackBar(SnackBar(
  //       content: GestureDetector(
  //         child: Text(
  //           data,
  //           maxLines: 3,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         // onTap: onTap,
  //       ),
  //       duration: Duration(seconds: time ?? 7),
  //     ));
  //   }
  // }
}
