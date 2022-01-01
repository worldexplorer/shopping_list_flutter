import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/network/incoming/incoming.dart';
import 'package:shopping_list_flutter/utils/theme.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

import 'package:shopping_list_flutter/utils/ui_notifier.dart';

class FlatTextField extends HookConsumerWidget {
  const FlatTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);
    final outgoingHandlers = incoming.outgoingHandlers;

    // final msgTyped = useState("");
    // var debounce = useState(Timer); // TODO: use river_pod

    sendMessageFromInput() {
      if (ui.msgInputCtrl.text.isEmpty) {
        return;
      }
      if (ui.isEditingMessageId > 0) {
        outgoingHandlers.sendEditMessage(
            ui.isEditingMessageId, ui.msgInputCtrl.text);
        ui.isEditingMessageId = 0;
      } else {
        outgoingHandlers.sendMessage(
            ui.msgInputCtrl.text, ui.isReplyingToMessageId);
      }
      ui.msgInputCtrl.clear();
    }

    return
        // Container(
        // decoration: BoxDecoration(
        //   color: altColor,
        //   borderRadius: BorderRadius.circular(6),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.05),
        //       blurRadius: 10,
        //     )
        //   ],
        // ),
        // child:
        Container(
      color: altColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.add_outlined,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          //prefix ?? SizedBox(width: 0, height: 0,),
          // https://stackoverflow.com/questions/57803737/flutter-renderflex-children-have-non-zero-flex-but-incoming-height-constraints
          Expanded(
            child: TextField(
                // onChanged: (String text) {
                //   outgoing.sendTyping(true);
                //   if (debounce.value.isActive ?? false) debounce.cancel();
                //   debounce = Timer(const Duration(milliseconds: 2000), () {
                //     outgoing.sendTyping(false);
                //   });
                // },
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 12,
                onSubmitted: (txt) => sendMessageFromInput,
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
              size: 24.0,
              color: Colors.green,
            ),
            onPressed: sendMessageFromInput,
          ),
        ],
        // ),
      ),
    );
  }
}
