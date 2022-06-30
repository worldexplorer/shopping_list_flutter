import 'package:flutter/material.dart';

import '../../network/incoming/incoming_state.dart';
import '../../widget/context_menu.dart';
import '../../widget/editable.dart';
import '../theme.dart';

Widget roomLeading(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back,
        size: 20,
        // color: whiteOrConnecting(socketConnected)
        color: Colors.white),
    onPressed: () {
      // ui.toMenuAndBack();
      Navigator.of(context).pop();
    },
  );
}

Widget roomTitle(
    IncomingState incoming, int roomId, bool socketConnected, String subtitle,
    [Function()? onTap]) {
  return Editable(
      text: incoming.rooms.currentRoomNameOrFetching,
      onSubmitted: (newText) {
        incoming.outgoingHandlers.sendRenameRoom(roomId, newText);
      },
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleText(true, incoming.rooms.currentRoomNameOrFetching),
        if (incoming.typing.isNotEmpty) ...[
          Text(
            incoming.typing,
            style: chatSliverSubtitleStyle(),
          ),
        ] else ...[
          subtitleText(socketConnected, subtitle),
        ]
      ]));
}

Widget roomActionsDropdown(BuildContext context, List<CtxMenuItem> ctxItems) {
  return IconButton(
    icon: const Icon(Icons.more_vert),
    onPressed: () {
      showPopupMenu(
          offset: const Offset(-80, 70), context: context, ctxItems: ctxItems);
    },
  );
}
