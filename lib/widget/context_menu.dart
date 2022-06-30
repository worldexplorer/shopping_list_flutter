import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../views/theme.dart';

class CtxMenuItem {
  String title;
  Function()? onTap;
  bool enabled = true;
  // TextStyle? textStyle;
  // Icon? icon;
  Widget? widget;

  CtxMenuItem({
    required this.title,
    this.onTap,
    // this.textStyle,
    // this.icon,
    this.widget,
  });
}

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
    useRootNavigator: true,
    color: Colors.blueGrey,
    context: context,
    // position: const RelativeRect.fromLTRB(200, 200, 0, 0),
    position: RelativeRect.fromLTRB(
      offset.dx > 0 ? offset.dx : screenSize.width + offset.dx,
      offset.dy,
      // 0,
      // 0
      offset.dx > 0 ? screenSize.width - offset.dx : offset.dx,
      screenSize.height - offset.dy,
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    items: ctxItems
        .map((ctxItem) => PopupMenuItem(
              // value: x.value,
              textStyle: textStyle ?? ctxMenuItemTextStyle,
              // enabled: x.enabled,
              onTap: () {
                // debugPrint('itemCallback(${x.title}:${x.value})');
                ctxItem.onTap?.call();
              },
              // value: x.value,
              child: ctxItem.widget ?? Text(ctxItem.title),
            ))
        .toList(),
    // elevation: 8.0,
  ).then((value) {
    if (value == null) {
      // NOTE: even you didn't select item this method will be called
      // with null of value so you should call your call back
      // with checking if value is not null
    } else {
      debugPrint('valueCallback($value)');
      //valueTapped?.(value);
    }
    onClosed?.call();
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
      onOpened?.call();
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
