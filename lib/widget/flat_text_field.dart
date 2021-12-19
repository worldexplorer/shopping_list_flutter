import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/network/outgoing/outgoing_notifier.dart';
import 'package:shopping_list_flutter/utils/theme.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';

class FlatTextField extends HookWidget {
  TextEditingController msgInputCtrl = TextEditingController();

  FlatTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<OutgoingNotifier, UiNotifier>(
        builder: (context, outgoing, ui, child) {
      sendMessageFromInput() {
        if (msgInputCtrl.text.isEmpty) {
          return;
        }
        outgoing.sendMessage(msgInputCtrl.text);
        msgInputCtrl.clear();
      }

      return Container(
        decoration: BoxDecoration(
          color: altColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //prefix ?? SizedBox(width: 0, height: 0,),
              Expanded(
                child: TextField(
                    onChanged: (String text) {
                      outgoing.sendTyping(true);
                      if (ui.debounce?.isActive ?? false) ui.debounce?.cancel();
                      ui.debounce =
                          Timer(const Duration(milliseconds: 2000), () {
                        outgoing.sendTyping(false);
                      });
                    },
                    textInputAction: TextInputAction.send,
                    onSubmitted: (txt) => sendMessageFromInput,
                    controller: msgInputCtrl,
                    decoration: InputDecoration(
                      hintText: "Enter Message...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(
                        16.0,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white)),
              ),

              IconButton(
                icon: const Icon(
                  FluentIcons.send_28_filled,
                  size: 24.0,
                  color: Colors.green,
                ),
                onPressed: sendMessageFromInput,
              ),
            ],
          ),
        ),
      );
    });
  }
}
