import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/pur_item_dto.dart';

import 'grouping.dart';
import 'pgroup_edit.dart';
import 'purchase_item_edit.dart';

class PurchaseEdit extends HookConsumerWidget {
  final PurchaseDto purchase;
  final int messageId;
  // final PurItemDto? newItemToFocus;

  PurchaseEdit({
    Key? key,
    required this.purchase,
    required this.messageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    final grouping = useState(Grouping(purchase.purItems));

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

    onSaveButtonPressed() {
      if (purchase.id == 0) {
        incoming.outgoingHandlers
            .sendNewPurchase(purchase, ui.isReplyingToMessageId);
        //TODO: move to incomingHandlers.onPurchaseCreated
        incoming.newPurchaseItem = null;
      } else {
        try {
          incoming.outgoingHandlers.sendEditPurchase(purchase);

          //TODO: move to incomingHandlers.onPurchaseEdited
          ui.messagesSelected.remove(purchase.message);

          final indexFound = incoming.messageItems
              .indexWhere((x) => x.message.id == messageId);
          incoming.messageItems[indexFound].selected = false;
          ui.rebuild();
        } catch (e) {
          StaticLogger.append(
              'SavePurchase(): ERROR deselecting an existing Purchase: ${e.toString()}');
        }
      }
    }

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
                              contentPadding: textInputPadding,
                              // fillColor: altColor,
                              // // border: InputBorder.none,
                              // border: const UnderlineInputBorder(
                              //     // borderSide: BorderSide(),
                              //     // borderRadius: BorderRadius.circular(6),
                              //     )
                            ),
                            style: textInputStyle))),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      // fixedSize: const Size(20, 20)
                    ),
                    child: const Icon(Icons.save,
                        size: iconSize, color: Colors.white),
                    onPressed: onSaveButtonPressed),
              ]),
          const SizedBox(height: 5),
          ...flatOrGrouped(grouping, ui),
          const SizedBox(height: 5),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 30),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          final newItemToFocus =
                              PurItemDto(id: 0, bought: false, name: '');
                          purchase.purItems.add(newItemToFocus);
                          ui.rebuild();
                        },
                        child: Row(children: [
                          const Icon(Icons.add_circle_outline,
                              size: iconSize, color: Colors.white),
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
                    const Icon(Icons.clear,
                        size: iconSize, color: Colors.white),
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
                              (bool newValue) {
                            purchase.show_pgroup = newValue;
                          }, ui),
                          toggle('Show Total', purchase.show_price,
                              (bool newValue) {
                            purchase.show_price = newValue;
                          }, ui),
                          toggle('Show Quantity', purchase.show_qnty,
                              (bool newValue) {
                            purchase.show_qnty = newValue;
                          }, ui),
                          toggle('Show Weight', purchase.show_weight,
                              (bool newValue) {
                            purchase.show_weight = newValue;
                          }, ui)
                        ]))),
        ]);
  }

  Widget toggle(
      String title, bool value, Function(bool newValue) onChange, UiState ui) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: value,
          onChanged: (newValue) {
            onChange(newValue);
            ui.rebuild();
          },
        ),
        const SizedBox(width: 3),
        Expanded(
            child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            onChange(!value);
            ui.rebuild();
          },
          child: Text(title, style: purchaseStyle),
        )),
      ],
    );
  }

  Iterable<Widget> flatOrGrouped(
      ValueNotifier<Grouping> groupingNotifier, UiState ui) {
    if (purchase.show_pgroup) {
      final grouping = groupingNotifier.value;
      // grouping.buildGroups();

      final List<Widget> ret = [];
      for (var idPgroup in grouping.pgroupById.entries) {
        final int pgroupId = idPgroup.key;
        final String pgroupName = idPgroup.value;

        ret.add(PgroupEdit(
            key: Key('$pgroupId'),
            name: pgroupName,
            onChanged: (newName) {
              final addedOrRemoved =
                  grouping.changeGroupName(pgroupId, newName);
              if (addedOrRemoved) {
                ui.rebuild();
              }
            },
            canDelete: grouping.canDeleteGroup(pgroupId),
            onDelete: () {
              grouping.deleteGroup(pgroupId);
              ui.rebuild();
            }));

        for (var product in grouping.productsByPgroup[pgroupId] ?? []) {
          ret.add(PurchaseItemEdit(
            key: Key(DateTime.now().microsecond.toString()),
            purchase: purchase,
            purItem: product,
          ));
        }
      }
      return ret;
    } else {
      return purchase.purItems.map((x) => PurchaseItemEdit(
            key: Key(DateTime.now().microsecond.toString()),
            purchase: purchase,
            purItem: x,
          ));

      // ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: purchase.purItems.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final purItem = purchase.purItems[index];
      //     final widget = PurchaseItemEdit(
      //       key: Key(DateTime.now().microsecond.toString()),
      //       purchase: purchase,
      //       purItem: purItem,
      //       isMe: isMe,
      //     );
      //     // return Text(purItem.name, softWrap: true, style: purchaseStyle);
      //     return widget;
      //   },
      // ),
    }
  }
}
