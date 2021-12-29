import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/widget/context_menu.dart';

class Log extends HookWidget {
  late TextStyle ctxMenuItemTextStyle;
  late CtxMenuItem clearCtx;

  Log({Key? key}) : super(key: key) {
    ctxMenuItemTextStyle = GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.8),
      fontSize: 15,
    );

    clearCtx = CtxMenuItem(
      // value: 'clear',
      'Clear',
      // true,
      () {
        StaticLogger.clear();
      },
      // ctxMenuItemTextStyle,
    );
  }

  @override
  build(BuildContext context) {
    final text = StaticLogger.dumpAll('\n\n');
    final tapGlobalPosition = useState(const Offset(0, 0));

    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: addContextMenu(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.0,
                // letterSpacing: 1,
                // wordSpacing: 1,
              ),
            ),
            tapGlobalPosition: tapGlobalPosition,
            context: context,
            items: [clearCtx],
            textStyle: ctxMenuItemTextStyle,
            onItemTap: () {},
            onOpened: () {},
            onClosed: () {}),
      ),
    );
  }
}
