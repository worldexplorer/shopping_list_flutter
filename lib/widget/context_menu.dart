import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CtxMenuItem {
//  T value;
  String title;
  // bool enabled;
  Function() onTap;
  // TextStyle? textStyle;
  // Icon? icon;

  CtxMenuItem(
    // this.value,
    this.title,
    // this.enabled,
    this.onTap,
    // this.textStyle,
    // this.icon,
  );
}

// https://stackoverflow.com/questions/50758121/how-dynamically-create-and-show-a-popup-menu-in-flutter
showPopupMenu({
  required Offset offset,
  required BuildContext context,
  required List<CtxMenuItem> ctxItems,
  required TextStyle textStyle,
  required Function() onClosed,
  // [Function(T valueTapped)? valueTapped]
}) async {
  HapticFeedback.vibrate();

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
              textStyle: textStyle,
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
    onClosed();
  });
}

// TODO: convert to a new HOOK, move tapGlobalPosition to a local variable
Widget wrapWithContextMenu<T extends Widget>({
  required T child,
  required BuildContext context,
  required List<CtxMenuItem> items,
  required TextStyle textStyle,
  required ValueNotifier<Offset> tapGlobalPosition,
  required Function() onItemTap,
  required Function() onOpened,
  required Function() onClosed,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onItemTap(),
    onLongPressDown: (LongPressDownDetails details) {
      tapGlobalPosition.value = details.globalPosition;
    },
    onLongPress: () async {
      onOpened();
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
