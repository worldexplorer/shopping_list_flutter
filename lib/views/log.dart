import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';
import 'package:shopping_list_flutter/widget/context_menu.dart';

class Log extends HookConsumerWidget {
  const Log({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final text = StaticLogger.dumpAll('\n\n');
    final tapGlobalPosition = useState(const Offset(0, 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        // padding: const EdgeInsets.all(3.0),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.blue,
        //     width: 1,
        //   ),
        // ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: wrapWithContextMenu(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 13.0,
                // letterSpacing: 1,
                // wordSpacing: 1,
              ),
            ),
            tapGlobalPosition: tapGlobalPosition,
            context: context,
            items: [
              CtxMenuItem(
                'Clear',
                () {
                  StaticLogger.clear();
                  ui.rebuild();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
