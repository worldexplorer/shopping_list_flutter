import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/purchase/pur_item_dto.dart';
import '../../network/incoming/purchase/purchase_dto.dart';
import '../../utils/static_logger.dart';
import '../../utils/ui_state.dart';
import '../theme.dart';
import 'grouping.dart';
import 'pgroup_edit.dart';
import 'purchase_item_edit.dart';
import 'puritem_states.dart';

class PurchaseEdit extends HookConsumerWidget {
  final int messageId;
  final PurchaseDto purchase;
  final PurchaseDto purchaseClone;

  const PurchaseEdit({
    Key? key,
    required this.messageId,
    required this.purchase,
    required this.purchaseClone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    final purchaseState = useState(purchaseClone);
    final purchase = purchaseState.value;

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
          (incoming.newPurchaseMessageItem != null ? ' Purchase' : ' Editing');
    }

    final ValueNotifier<List<PurchaseItemEdit>> purItemEditors = useState(
        purchase.purItems
            .map(
                (purItem) =>
                    createPurItemEditor(purchase, purItem, pgroupFocused),
                addProduct)
            .toList());

    addProduct(int? pgroupId, [int? index]) {
      final newPurItem = PurItemDto(
        id: 0,
        bought: 0,
        name: '',
        pgroup_id: pgroupId,
      );

      final editor =
          createPurItemEditor(purchase, newPurItem, pgroupFocused, addProduct);

      if (index != null) {
        purchase.purItems.insert(index, newPurItem);
        purItemEditors.value.insert(index, editor);
      } else {
        purchase.purItems.add(newPurItem);
        purItemEditors.value.add(editor);
      }

      if (purchase.show_pgroup) {
        grouping.value.addProduct(newPurItem);
      }
      ui.rebuild();
    }

    onSaveButtonPressed() {
      if (purchase.show_pgroup) {
        grouping.value.fillExistingPgroupNamesBeforeSave(purchase.purItems);
        grouping.value.fillChangedProductNamesBeforeSave(purchase.purItems);
      }
      removeEmptyPuritemsBeforeSave(purchase.show_pgroup, purchase.purItems);
      if (purchase.id == 0) {
        incoming.outgoingHandlers
            .sendNewPurchase(purchase, ui.isReplyingToMessageId);
        //TODO: move to incomingHandlers.onPurchaseCreated
        incoming.newPurchaseMessageItem = null;
      } else {
        try {
          incoming.outgoingHandlers.sendEditPurchase(purchase);

          //TODO: move to incomingHandlers.onPurchaseEdited
          ui.messagesSelected.remove(purchase.message);

          final indexFound = incoming.rooms.currentRoomMessages.messageWidgets
              .indexWhere((x) => x.message.id == messageId);
          incoming.rooms.currentRoomMessages.messageWidgets[indexFound]
              .selected = false;
          ui.rebuild();
        } catch (e) {
          StaticLogger.append(
              'SavePurchase(): ERROR deselecting an existing Purchase: ${e.toString()}');
        }
      }
    }

    onCancelButtonPressed() {
      if (incoming.newPurchaseMessageItem != null) {
        incoming.newPurchaseMessageItem = null;
      } else {
        ui.messagesSelected.remove(messageId);

        final msgWidget =
            incoming.rooms.currentRoomMessages.messageWidgetById[messageId];
        if (msgWidget != null) {
          msgWidget.selected = false;
        }

        ui.rebuild();
      }
    }

    List<Widget> flatOrGrouped() {
      return purchase.show_pgroup
          ? groupedEditors(grouping, purchase, ui, pgroupFocused, addProduct)
          : purItemEditors.value;
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
                            enableSuggestions: true,
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
                        size: sendMessageInputIconSize, color: Colors.white),
                    onPressed: onSaveButtonPressed),
              ]),
          const SizedBox(height: 5),

          ...flatOrGrouped(),

          const SizedBox(height: 5),
          if (settingsExpanded.value)
            // Wrap(
            //     direction: Axis.horizontal,
            //     alignment: WrapAlignment.start,
            //     spacing: 20,
            //     runAlignment: WrapAlignment.start,
            //     runSpacing: 5,
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('Show: ', style: purchaseStyle),
                  // const SizedBox(width: 5),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        toggleText('Groups', purchase.show_pgroup,
                            (bool newShowGroups) {
                          purchase.show_pgroup = newShowGroups;
                          ui.newPurchaseSettings.showPgroups = newShowGroups;
                          if (newShowGroups == false) {
                            pgroupFocused.value = null;
                            removeEmptyPuritemsLeaveOnlyLast(purchase.purItems);
                          } else {
                            pgroupFocused.value = grouping.value.lastGroup;
                          }
                        }, ui),
                        // Padding(
                        //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //     child:
                        toggleText('Sequence', purchase.show_serno,
                            (bool newShowSerno) {
                          purchase.show_serno = newShowSerno;
                          ui.newPurchaseSettings.showSerno = newShowSerno;
                        }, ui),
                        toggleIconText(iconByBought(BOUGHT_UNKNOWN),
                            'Waiting state', purchase.show_state_unknown,
                            (bool newShowThreeState) {
                          purchase.show_state_unknown = newShowThreeState;
                          ui.newPurchaseSettings.showStateUnknown =
                              newShowThreeState;
                        }, ui),
                        toggleIconText(iconByBought(BOUGHT_STOP), 'Stop state',
                            purchase.show_state_stop, (bool newShowStateStop) {
                          purchase.show_state_stop = newShowStateStop;
                          ui.newPurchaseSettings.showStateStop =
                              newShowStateStop;
                        }, ui),
                        toggleIconText(iconByBought(BOUGHT_QUESTION),
                            'Question state', purchase.show_state_question,
                            (bool newShowStateQuestion) {
                          purchase.show_state_question = newShowStateQuestion;
                          ui.newPurchaseSettings.showStateQuestion =
                              newShowStateQuestion;
                        }, ui),
                        toggleIconText(iconByBought(BOUGHT_HALFODNE),
                            'Half Done', purchase.show_state_halfdone,
                            (bool newShowStateHalfDone) {
                          purchase.show_state_halfdone = newShowStateHalfDone;
                          ui.newPurchaseSettings.showStateHalfDone =
                              newShowStateHalfDone;
                        }, ui),
                      ]),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Spacer(),
                              if (!incoming.thisPurchaseIsNew(purchase))
                                ElevatedButton(
                                    child: const Icon(Icons.undo_rounded,
                                        color: Colors.white,
                                        size: sendMessageInputIconSize),
                                    onPressed: onCancelButtonPressed),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  child: const Icon(Icons.save,
                                      color: Colors.white,
                                      size: sendMessageInputIconSize),
                                  onPressed: onSaveButtonPressed),
                            ]),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  toggleText('Quantity', purchase.show_qnty,
                                      (bool newShowQnty) {
                                    purchase.show_qnty = newShowQnty;
                                    ui.newPurchaseSettings.showQnty =
                                        newShowQnty;
                                  }, ui),
                                  toggleText('Total', purchase.show_price,
                                      (bool newShowPrice) {
                                    purchase.show_price = newShowPrice;
                                    ui.newPurchaseSettings.showPrice =
                                        newShowPrice;
                                  }, ui),
                                  toggleText('Weight', purchase.show_weight,
                                      (bool newShowWeight) {
                                    purchase.show_weight = newShowWeight;
                                    ui.newPurchaseSettings.showWeight =
                                        newShowWeight;
                                  }, ui)
                                ])),
                      ])),
                ]),
          // if (settingsExpanded.value)
          //   const Divider(height: 10, thickness: 1, indent: 3),
          // if (settingsExpanded.value) const SizedBox(height: 5),
          if (incoming.thisPurchaseIsNew(purchase))
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (incoming.thisPurchaseIsNew(purchase)) ...[
                    // away from left round phone corner
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onCancelButtonPressed,
                      child: Row(children: [
                        const Icon(Icons.clear,
                            size: sendMessageInputIconSize,
                            color: Colors.white),
                        const SizedBox(width: 10),
                        Text(btnLabelCancelPurchase, style: purchaseStyle),
                      ]),
                    ),
                    const Spacer()
                  ],
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
        ]);
  }
}

Widget toggleText(
    String title, bool value, Function(bool newValue) onChange, UiState ui) {
  return toggle(Text(title, style: purchaseStyle), value, onChange, ui);
}

Widget toggleIconText(Icon icon, String title, bool value,
    Function(bool newValue) onChange, UiState ui) {
  return toggle(
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(title, style: purchaseStyle)
          ]),
      value,
      onChange,
      ui);
}

Widget toggle(Widget textOrIcon, bool value, Function(bool newValue) onChange,
    UiState ui) {
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
        child: textOrIcon,
        // )
      ),
    ],
  );
}

List<Widget> groupedEditors(
    ValueNotifier<Grouping> groupingNotifier,
    PurchaseDto purchase,
    UiState ui,
    ValueNotifier<int?> pgroupFocused,
    Function(int?, [int?]) addProduct) {
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
        onTapNotifyFocused: () {
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
        onTapNotifyFocused: () {
          pgroupFocused.value = pgroupId;
        },
        onChangedAddProduct: (newName) {
          final shouldAddProductBelow = grouping.productNameChanged(product);
          if (shouldAddProductBelow) {
            addProduct(pgroupId);
          }
        },
        canDelete: grouping.canDeleteProduct(product, pgroupId, pgroupName),
        onDelete: () {
          if (purchase.show_pgroup) {
            grouping.deleteProduct(product);
          }
        },
        onEnter: () {
          addProduct(null, indexProduct + 1);
        },
        autofocus: false,
      ));
    }
  }
  return ret;
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
  // }
}

int i = 0;
PurchaseItemEdit createPurItemEditor(
    PurchaseDto purchase, PurItemDto purItem, ValueNotifier<int?> pgroupFocused,
    [Function(int?, [int?])? addProduct, bool autofocus = false]) {
  return PurchaseItemEdit(
    key: Key('${i++}:${purItem.id}:${purItem.pgroup_id}:${purItem.product_id}'),
    purchase: purchase,
    purItem: purItem,
    onTapNotifyFocused: () {
      pgroupFocused.value = null;
    },
    onChangedAddProduct: (newName) {
      final shouldAddProduct = allPurItemsHaveName(purchase.purItems);
      if (shouldAddProduct) {
        if (addProduct != null) {
          addProduct(null);
        }
      }
    },
    canDelete: true,
    onDelete: () {},
    onEnter: () {
      if (addProduct != null) {
        addProduct(null, i + 1);
      }
    },
    autofocus: autofocus,
  );
}
