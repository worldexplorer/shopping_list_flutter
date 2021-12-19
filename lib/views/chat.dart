import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list_flutter/network/incoming/incoming_notifier.dart';
import 'package:shopping_list_flutter/utils/margin.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/widget/flat_text_field.dart';

class Chat extends HookWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomingNotifier>(builder: (context, incoming, child) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              FluentIcons.arrow_left_28_filled,
            ),
            onPressed: () {
              // context.read(mapVM).tabController.animateTo(0);
            },
          ),
          centerTitle: true,
          title: Column(
            children: [
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
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
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
            ],
          ),
        ),
      );
    });
  }
}
