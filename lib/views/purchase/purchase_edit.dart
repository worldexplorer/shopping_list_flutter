import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/theme.dart';
import '../../utils/ui_notifier.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/pur_item_dto.dart';

import 'purchase_item_edit.dart';

class PurchaseEdit extends HookConsumerWidget {
  PurchaseDto purchase;
  final bool isMe;
  final int messageId;

  PurchaseEdit({
    Key? key,
    required this.purchase,
    required this.messageId,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incomingState = ref.watch(incomingStateProvider);

    final titleInputCtrl = useTextEditingController();
    titleInputCtrl.text = purchase.name;

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                        decoration: textInputDecoration,
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: TextField(
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            controller: titleInputCtrl,
                            decoration: InputDecoration(
                              hintText: 'Enter Purchase title...',
                              hintStyle: textInputHintStyle,
                              // border: InputBorder.none,
                              contentPadding: textInputPadding,
                            ),
                            style: textInputStyle))),
                IconButton(
                    icon: const Icon(Icons.save, size: 24, color: Colors.blue),
                    enableFeedback: true,
                    autofocus: true,
                    onPressed: () {
                      ui.messagesSelected.remove(purchase.message);
                      final indexFound = incomingState.messageItems
                          .indexWhere((x) => x.message.id == messageId);
                      incomingState.messageItems[indexFound].selected = false;
                      ui.rebuild();
                      HapticFeedback.vibrate();
                    }),
              ]),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: purchase.purItems.length,
            itemBuilder: (BuildContext context, int index) {
              final purItem = purchase.purItems[index];
              return PurchaseItemEdit(
                purchase: purchase,
                purItem: purItem,
                isMe: isMe,
              );
              // return Text(purItem.name, softWrap: true, style: purchaseStyle);
            },
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                IconButton(
                    icon: const Icon(Icons.add_circle,
                        size: 24, color: Colors.blue),
                    enableFeedback: true,
                    autofocus: true,
                    onPressed: () {
                      purchase.purItems.add(PurItemDto(id: 0, name: ''));
                      ui.rebuild();
                    }),
                const SizedBox(width: 10),
                const Text('Add Product...',
                    style: TextStyle(color: Colors.white))
              ]),
          const Divider(height: 4, thickness: 1, indent: 3),
          toggle('Show Groups', purchase.show_pgroup, (int newValue) {
            purchase.show_pgroup = newValue;
          }, ui),
          toggle('Show total', purchase.show_price, (int newValue) {
            purchase.show_price = newValue;
          }, ui),
          toggle('Show Quantity', purchase.show_qnty, (int newValue) {
            purchase.show_qnty = newValue;
          }, ui),
          toggle('Show weight', purchase.show_weight, (int newValue) {
            purchase.show_weight = newValue;
          }, ui),
        ]);
  }

  Widget toggle(
      String title, int value, Function(int newValue) onChange, UiState ui) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(
          value: value == 0 ? false : true,
          onChanged: (newValue) {
            onChange(newValue ? 1 : 0);
            ui.rebuild();
          },
        ),
        const SizedBox(width: 3),
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            onChange(value == 0 ? 1 : 0);
            ui.rebuild();
          },
          child: Text(title, style: purchaseStyle),
        ),
      ],
    );
  }
}
