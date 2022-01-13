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

  const PurchaseEdit({
    Key? key,
    required this.purchase,
    required this.messageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    final settingsExpanded = useState(true);
    final grouping = useState(Grouping(purchase.purItems));
    final ValueNotifier<int?> pgroupFocused = useState(null);

    final titleInputCtrl = useTextEditingController();
    titleInputCtrl.text = purchase.name;

    final widthAfterRebuild = MediaQuery.of(context).size.width;

    const wideEnough = 600;

    String btnLabelCancelPurchase = 'Cancel';
    if (widthAfterRebuild > wideEnough) {
      btnLabelCancelPurchase +=
          (incoming.newPurchaseItem != null ? ' Purchase' : ' Editing');
    }

    double addCancelSpace = (widthAfterRebuild > wideEnough) ? 50 : 20;

    addProduct(int? pgroup_id) {
      final newItemToFocus = PurItemDto(
        id: 0,
        bought: false,
        name: '',
        pgroup_id: pgroup_id,
      );
      purchase.purItems.add(newItemToFocus);
      if (purchase.show_pgroup) {
        grouping.value.addProduct(newItemToFocus);
      }
      ui.rebuild();
    }

    onSaveButtonPressed() {
      removeEmptyPuritemsBeforeSave(purchase.show_pgroup, purchase.purItems);
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
          ...flatOrGrouped(grouping, ui, pgroupFocused, addProduct),
          const SizedBox(height: 5),
          if (incoming.newPurchaseItem != null)
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: addCancelSpace),
                  ElevatedButton(
                    onPressed: () {
                      incoming.newPurchaseItem = null;
                      // } else {
                      //   ui.messagesSelected.remove(messageId);
                      //   ui.rebuild();
                      //
                      //   final msgItem = incoming.messageItemsById[messageId];
                      //   if (msgItem != null) {
                      //     msgItem.selected = false;
                      //   }
                      // }
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
          // const SizedBox(height: 5),
          const Divider(height: 10, thickness: 1, indent: 3),
          if (settingsExpanded.value)
            Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                spacing: 15,
                runAlignment: WrapAlignment.spaceEvenly,
                runSpacing: 5,
                children: [
                  // Text('Show: ', style: purchaseStyle),
                  // const SizedBox(width: 5),
                  toggle('Groups', purchase.show_pgroup, (bool newShowGroups) {
                    purchase.show_pgroup = newShowGroups;
                    ui.newPurchaseSettings.showPgroups = newShowGroups;
                    if (newShowGroups == false) {
                      pgroupFocused.value = null;
                      removeEmptyPuritemsLeaveOnlyLast(purchase.purItems);
                    } else {
                      pgroupFocused.value = grouping.value.lastGroup;
                    }
                  }, ui),
                  toggle('Sequence', purchase.show_serno, (bool newShowSerno) {
                    purchase.show_serno = newShowSerno;
                    ui.newPurchaseSettings.showSerno = newShowSerno;
                  }, ui),
                  toggle('Quantity', purchase.show_qnty, (bool newShowQnty) {
                    purchase.show_qnty = newShowQnty;
                    ui.newPurchaseSettings.showQnty = newShowQnty;
                  }, ui),
                  toggle('Total', purchase.show_price, (bool newShowPrice) {
                    purchase.show_price = newShowPrice;
                    ui.newPurchaseSettings.showPrice = newShowPrice;
                  }, ui),
                  toggle('Weight', purchase.show_weight, (bool newShowWeight) {
                    purchase.show_weight = newShowWeight;
                    ui.newPurchaseSettings.showWeight = newShowWeight;
                  }, ui),
                  toggle('Three-state', purchase.show_threestate,
                      (bool newShowThreeState) {
                    purchase.show_threestate = newShowThreeState;
                    ui.newPurchaseSettings.showThreeState = newShowThreeState;
                  }, ui),
                ]),
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
        // const SizedBox(width: 3),
        // Expanded(
        //     child:
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            onChange(!value);
            ui.rebuild();
          },
          child: Text(title, style: purchaseStyle),
          // )
        ),
      ],
    );
  }

  Iterable<Widget> flatOrGrouped(
      ValueNotifier<Grouping> groupingNotifier,
      UiState ui,
      ValueNotifier<int?> pgroupFocused,
      Function(int?) addProduct) {
    if (purchase.show_pgroup) {
      final grouping = groupingNotifier.value;
      // grouping.buildGroups();

      final List<Widget> ret = [];

      int indexPgroup = 0;
      final hasDragHandle = grouping.pgroupById.length > 1;
      for (MapEntry<int, String> idPgroup in grouping.pgroupById.entries) {
        final int pgroupId = idPgroup.key;
        final String pgroupName = idPgroup.value;

        ret.add(PgroupEdit(
            key: Key('${indexPgroup++}:$pgroupId'),
            name: pgroupName,
            onFocused: () {
              pgroupFocused.value = pgroupId;
            },
            onChanged: (newName) {
              final addedNewGroupBelow =
                  grouping.changeGroupName(pgroupId, newName);
              if (addedNewGroupBelow) {
                // insert a new product into this group
                addProduct(pgroupId);
              }
            },
            canDelete: grouping.canDeleteGroup(pgroupId),
            onDelete: () {
              grouping.deleteGroup(pgroupId);
              ui.rebuild();
            },
            hasDragHandle: hasDragHandle));

        int indexProduct = 0;
        for (PurItemDto product in grouping.productsByPgroup[pgroupId] ?? []) {
          ret.add(PurchaseItemEdit(
            key: Key(
                '$indexPgroup:$pgroupId:${indexProduct++}:${product.product_id}'),
            purchase: purchase,
            purItem: product,
            onTap: () {
              pgroupFocused.value = pgroupId;
            },
            onChanged: (newName) {
              final shouldAddProductBelow =
                  grouping.productNameChanged(product);
              if (shouldAddProductBelow) {
                addProduct(pgroupId);
              }
            },
            onDeleted: () {
              if (purchase.show_pgroup) {
                grouping.deleteProduct(product);
              }
            },
          ));
        }
      }
      return ret;
    } else {
      int i = 1;
      return purchase.purItems.map((x) => PurchaseItemEdit(
            key: Key('${i++}:${x.id}:${x.pgroup_id}:${x.product_id}'),
            purchase: purchase,
            purItem: x,
            onTap: () {
              pgroupFocused.value = null;
            },
            onChanged: (newName) {
              final shouldAddProduct = allPurItemsHaveName(purchase.purItems);
              if (shouldAddProduct) {
                addProduct(null);
              }
            },
            onDeleted: () {},
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
