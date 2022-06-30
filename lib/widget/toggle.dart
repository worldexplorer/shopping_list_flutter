import 'package:flutter/material.dart';

import '../utils/ui_state.dart';
import '../views/theme.dart';

Widget ToggleText(
    String title, bool value, Function(bool newValue) onChange, UiState ui) {
  return Toggle(Text(title, style: purchaseStyle), value, onChange, ui);
}

Widget ToggleIconText(Icon icon, String title, bool value,
    Function(bool newValue) onChange, UiState ui,
    [double spacing = 5.0]) {
  return Toggle(
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: spacing,
            ),
            Text(title, style: purchaseStyle)
          ]),
      value,
      onChange,
      ui);
}

Widget Toggle(Widget textOrIcon, bool value, Function(bool newValue) onChange,
    UiState ui) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Switch(
        value: value,
        onChanged: (newValue) {
          onChange(newValue);
          ui.rebuild();
        },
      ),
      // const SizedBox(width: 3),
      // Expanded(
      //     child:
      GestureDetector(
        onTapDown: (TapDownDetails details) {
          onChange(!value);
          ui.rebuild();
        },
        child: textOrIcon,
        // )
      ),
    ],
  );
}
