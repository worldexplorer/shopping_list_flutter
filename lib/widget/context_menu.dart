import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CtxMenuItem {
  String title;
  bool enabled = true;
  Function() onTap;
  // TextStyle? textStyle;
  // Icon? icon;

  CtxMenuItem(
    this.title,
    this.onTap,
    // this.textStyle,
    // this.icon,
  );
}

final TextStyle ctxMenuItemTextStyle = GoogleFonts.poppins(
  color: Colors.white.withOpacity(0.8),
  fontSize: 15,
);

// https://stackoverflow.com/questions/50758121/how-dynamically-create-and-show-a-popup-menu-in-flutter
showPopupMenu({
  required Offset offset,
  required BuildContext context,
  required List<CtxMenuItem> ctxItems,
  TextStyle? textStyle,
  Function()? onClosed,
  // [Function(T valueTapped)? valueTapped]
}) async {
  final screenSize = MediaQuery.of(context).size;
  await showMenu(
    color: Colors.blue,
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      screenSize.width - offset.dx,
      screenSize.height - offset.dy,
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    items: ctxItems
        .map((x) => PopupMenuItem(
              // value: x.value,
              child: Text(x.title),
              textStyle: textStyle ?? ctxMenuItemTextStyle,
              // enabled: x.enabled,
              onTap: () {
                // debugPrint('itemCallback(${x.title}:${x.value})');
                x.onTap();
              },
            ))
        .toList(),
    elevation: 8.0,
  ).then((value) {
    if (value == null) {
      // NOTE: even you didnt select item this method will be called
      // with null of value so you should call your call back
      // with checking if value is not null
    } else {
      debugPrint('valueCallback($value)');
      //valueTapped?.(value);
    }
    if (onClosed != null) {
      onClosed();
    }
  });
}

// TODO: convert to a new HOOK, move tapGlobalPosition to a local variable
Widget wrapWithContextMenu<T extends Widget>({
  required T child,
  required BuildContext context,
  required List<CtxMenuItem> items,
  required ValueNotifier<Offset> tapGlobalPosition,
  Function(TapUpDetails details)? onItemTapUp,
  TextStyle? textStyle,
  Function()? onOpened,
  Function()? onClosed,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTapUp: onItemTapUp,
    onLongPressDown: (LongPressDownDetails details) {
      tapGlobalPosition.value = details.globalPosition;
    },
    onLongPress: () async {
      if (onOpened != null) {
        onOpened();
      }
      await showPopupMenu(
          offset: tapGlobalPosition.value,
          context: context,
          ctxItems: items,
          textStyle: textStyle,
          onClosed: onClosed);
    },
    child: child,
  );
}
