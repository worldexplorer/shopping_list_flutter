import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/network/net_state.dart';
import 'package:shopping_list_flutter/utils/theme.dart';

class FlatTextField extends HookWidget {
  const FlatTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetState netState = Consumer();
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            //prefix ?? SizedBox(width: 0, height: 0,),
            Expanded(
              child: TextField(
                  onChanged: (String text) {
                    netState.sendTyping(true);
                    if (netState.debounce?.isActive ?? false)
                      netState.debounce?.cancel();
                    netState.debounce =
                        Timer(const Duration(milliseconds: 2000), () {
                      netState.sendTyping(false);
                    });
                  },
                  textInputAction: TextInputAction.send,
                  onSubmitted: (txt) => netState.sendMessage(),
                  controller: netState.msgInputCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter Message...",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(
                      16.0,
                    ),
                  ),
                  style: TextStyle(color: Colors.white)),
            ),

            IconButton(
              icon: Icon(
                FluentIcons.send_28_filled,
                size: 24.0,
                color: Colors.green,
              ),
              onPressed: netState.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
