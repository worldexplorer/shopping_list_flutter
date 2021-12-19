import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list_flutter/network/incoming/incoming_notifier.dart';
import 'package:shopping_list_flutter/utils/margin.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/widget/flat_text_field.dart';

class Chat extends HookWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _debugExpanded = useState(false);

    return Consumer<IncomingNotifier>(builder: (context, incoming, child) {
      return Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                pinned: true,
                floating: true,
                //_debugExpanded.value,
                leading: IconButton(
                  icon: const Icon(
                    // FluentIcons.settings_28_filled,
                    Icons.more_vert,
                    size: 20,
                  ),
                  onPressed: () {
                    // _debugExpanded.value = !_debugExpanded.value
                  },
                ),
                title: Column(children: [
                  Text(
                    '${incoming.currentRoom.name} (${incoming.currentRoomUsersCsv})',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                  if (incoming.typing.isNotEmpty) ...[
                    const YMargin(4),
                    Text(
                      incoming.typing,
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  ]
                ]),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  // PopSliverToBoxAdapter(upMenuButton(
                  //   child: Icon(Icons.more_vert),
                  //   itemBuilder: (BuildContext context) {
                  //     return <PopupMenuEntry>[
                  //       const PopupMenuItem(
                  //         child: Text('Not implemented'),
                  //       )
                  //     ];
                  //   },
                  // )),
                ],
                bottom: PreferredSize(
                  preferredSize:
                      Size.fromHeight(_debugExpanded.value ? 10 : 300),
                  child: _buildScrollingText(StaticLogger.dumpAll()),
                )),
            SliverFillRemaining(
              hasScrollBody: true,
              child: Column(children: [
                Flexible(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    children: [...incoming.getMessageItems],
                  ),
                ),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: FlatTextField()),
              ]),
            )
          ],
        ),
      );
    });
  }

  Widget _buildScrollingText2(String text) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: const TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 13,
            enabled: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Debug log here...',
              // fillColor: Colors.white,
              // filled: true,
            )));
  }

  Widget _buildScrollingText(String text) {
    return
        // Column(children: [
        //   Flexible(child:

        Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ), // // Column(children: [
      // // Flexible( child:

      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 16.0,
              letterSpacing: 1,
              wordSpacing: 1,
            ),
          ),
        ),
      ),
    )
        // )
        // ])
        ;
  }
}
