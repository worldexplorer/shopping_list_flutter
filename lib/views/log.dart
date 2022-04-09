import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';
import 'package:shopping_list_flutter/views/theme.dart';
import 'package:shopping_list_flutter/widget/context_menu.dart';

class Log extends HookConsumerWidget {
  final bool? showAppBar;
  const Log({Key? key, this.showAppBar}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final rebuildEveryBufferChanged =
        ref.watch(staticLoggerProvider); // DONT_REMOVE

    final tapGlobalPosition = useState(const Offset(0, 0));

    return Scaffold(
      backgroundColor: chatBackground,
      appBar: showAppBar == true
          ? AppBar(
              title: const Text('Log'),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(5.0),
        child: wrapWithContextMenu(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            reverse: true,
            itemCount: StaticLogger.buffer.length,
            itemBuilder: (BuildContext context, int index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  StaticLogger.buffer[StaticLogger.buffer.length - 1 - index],
                  style: logRecordStyle,
                )),
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
      // ),
    );
  }
}
