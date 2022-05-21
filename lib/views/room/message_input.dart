import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../utils/ui_state.dart';
import '../theme.dart';

class MessageInput extends HookConsumerWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);
    final outgoingHandlers = incoming.outgoingHandlers;

    var debounce = useState(Timer(Duration.zero, () {}));

    sendMessageFromInput() {
      if (incoming.rooms.isEditingMessageId > 0) {
        outgoingHandlers.sendEditMessage(
            incoming.rooms.isEditingMessageId, ui.msgInputCtrl.text);
        incoming.rooms.isEditingMessageId = 0;
      } else {
        outgoingHandlers.sendMessage(
            ui.msgInputCtrl.text, ui.isReplyingToMessageId);
      }
      ui.msgInputCtrl.clear();
    }

    return Container(
      color: altColor,
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
              icon: const Icon(
                Icons.add_outlined,
                color: Colors.green,
              ),
              onPressed: () =>
                  incoming.addEmptyPurchase(ui.newPurchaseSettings)),
          const SizedBox(width: 10),
          // https://stackoverflow.com/questions/57803737/flutter-renderflex-children-have-non-zero-flex-but-incoming-height-constraints
          Expanded(
            child: TextField(
                onChanged: (String text) {
                  outgoingHandlers.sendTyping(true);
                  if (debounce.value.isActive) debounce.value.cancel();
                  debounce.value =
                      Timer(const Duration(milliseconds: 2000), () {
                    outgoingHandlers.sendTyping(false);
                  });
                },
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 12,
                enableSuggestions: true,
                // onSubmitted: (txt) => sendMessageFromInput,
                controller: ui.msgInputCtrl,
                decoration: InputDecoration(
                  hintText: "Enter Message...",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(
                    0.0,
                    16.0,
                    0.0,
                    16.0,
                  ),
                ),
                style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(
              FluentIcons.send_28_filled,
              size: sendMessageInputIconSize,
              color: Colors.green,
            ),
            onPressed: sendMessageFromInput,
          ),
        ],
      ),
    );
  }
}
