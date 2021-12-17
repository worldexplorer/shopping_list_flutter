import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/network/net_state.dart';
import 'package:shopping_list_flutter/utils/margin.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/widget/flat_text_field.dart';

class Chat extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_28_filled,
          ),
          onPressed: () {
            context.read(mapVM).tabController.animateTo(0);
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Messages',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 19,
              ),
            ),
            if (provider.typing.isNotEmpty) ...[
              const YMargin(4),
              Text(
                provider.typing,
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
                padding: EdgeInsets.all(16),
                children: [...provider.messages],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Consumer<NetState>(builder: (context, netState, child) {
                return FlatTextField();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
