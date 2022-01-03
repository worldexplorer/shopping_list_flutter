import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
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
    final incoming = ref.watch(incomingStateProvider);

    final settingsExpanded = useState(false);

    final titleInputCtrl = useTextEditingController();
    titleInputCtrl.text = purchase.name;

    final widthAfterRebuild = MediaQuery.of(context).size.width;

    const wideEnough = 600;
    String btnLabelAddProduct =
        widthAfterRebuild > wideEnough ? 'Add Product...' : 'Add';

    String btnLabelCancelPurchase = 'Cancel';
    if (widthAfterRebuild > wideEnough) {
      btnLabelCancelPurchase +=
          (incoming.newPurchaseItem != null ? ' Purchase' : ' Editing');
    }

    double addCancelSpace = (widthAfterRebuild > wideEnough) ? 50 : 20;

    return Column(
        mainAxisSize: MainAxisSize.max,
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
                            onChanged: (String text) {
                              purchase.name = text;
                              // ui.rebuild();
                            },
                            decoration: InputDecoration(
                              hintText: 'Store name...',
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
                      if (incoming.newPurchaseItem == null) {
                        ui.messagesSelected.remove(purchase.message);
                        ui.rebuild();

                        final indexFound = incoming.messageItems
                            .indexWhere((x) => x.message.id == messageId);
                        incoming.messageItems[indexFound].selected = false;
                      }
                      StaticLogger.append(
                          'SavePurchase(): TODO: serialize to server');
                      HapticFeedback.vibrate();
                    }),
              ]),

          ...purchase.purItems.map((x) => PurchaseItemEdit(
                key: Key(DateTime.now().microsecond.toString()),
                purchase: purchase,
                purItem: x,
                isMe: isMe,
              )),

          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: purchase.purItems.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final purItem = purchase.purItems[index];
          //     return PurchaseItemEdit(
          //       key: Key(DateTime.now().microsecond.toString()),
          //       purchase: purchase,
          //       purItem: purItem,
          //       isMe: isMe,
          //     );
          //     // return Text(purItem.name, softWrap: true, style: purchaseStyle);
          //   },
          // ),

          const SizedBox(height: 5),

          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 30),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          purchase.purItems.add(PurItemDto(id: 0, name: ''));
                          ui.rebuild();
                        },
                        child: Row(children: [
                          const Icon(Icons.add_circle_outline,
                              size: 24, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(btnLabelAddProduct, style: purchaseStyle)
                        ]))),
                SizedBox(width: addCancelSpace),
                ElevatedButton(
                  onPressed: () {
                    if (incoming.newPurchaseItem != null) {
                      incoming.newPurchaseItem = null;
                    } else {
                      ui.messagesSelected.remove(messageId);
                      ui.rebuild();

                      final msgItem = incoming.messageItemsById[messageId];
                      if (msgItem != null) {
                        msgItem.selected = false;
                      }
                    }
                  },
                  child: Row(children: [
                    const Icon(Icons.clear, size: 24, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(btnLabelCancelPurchase, style: purchaseStyle),
                  ]),
                ),
                const SizedBox(width: 10),
                IconButton(
                    icon: Icon(
                        settingsExpanded.value
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down_outlined,
                        size: 32,
                        color: Colors.blue),
                    enableFeedback: true,
                    // autofocus: true,
                    onPressed: () {
                      settingsExpanded.value = !settingsExpanded.value;
                    }),
              ]),

          const SizedBox(height: 5),

          if (settingsExpanded.value)
            Container(
                alignment: Alignment.topRight,
                child: SizedBox(
                    width: 200,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Divider(height: 4, thickness: 1, indent: 3),
                          toggle('Show Groups', purchase.show_pgroup,
                              (int newValue) {
                            purchase.show_pgroup = newValue;
                          }, ui),
                          toggle('Show Total', purchase.show_price,
                              (int newValue) {
                            purchase.show_price = newValue;
                          }, ui),
                          toggle('Show Quantity', purchase.show_qnty,
                              (int newValue) {
                            purchase.show_qnty = newValue;
                          }, ui),
                          toggle('Show Weight', purchase.show_weight,
                              (int newValue) {
                            purchase.show_weight = newValue;
                          }, ui)
                        ]))),
        ]);
  }

  Widget toggle(
      String title, int value, Function(int newValue) onChange, UiState ui) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: value == 0 ? false : true,
          onChanged: (newValue) {
            onChange(newValue ? 1 : 0);
            ui.rebuild();
          },
        ),
        const SizedBox(width: 3),
        Expanded(
            child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            onChange(value == 0 ? 1 : 0);
            ui.rebuild();
          },
          child: Text(title, style: purchaseStyle),
        )),
      ],
    );
  }
}
