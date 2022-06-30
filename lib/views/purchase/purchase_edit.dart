import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/purchase/pur_item_dto.dart';
import '../../network/incoming/purchase/purchase_dto.dart';
import '../../utils/static_logger.dart';
import '../../utils/ui_state.dart';
import '../../widget/toggle.dart';
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
    final ValueNotifier<Grouping> grouping =
        useState(Grouping(purchase.purItems));
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

    late ValueNotifier<List<PurchaseItemEdit>> purItemEditors = useState([]);

    if (purItemEditors.value.isEmpty) {
      // initialization each time will cause AUTOFOCUS_ON_STORE_NAME
      purItemEditors.value = purchase.purItems
          .map((purItem) => createPurItemEditor(
              purchase, purItem, pgroupFocused, purItemEditors, grouping, ui))
          .toList();
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

    addPurItemDtoShort(int? pgroupId, [int? insertIndex]) {
      addPurItemDto(purchase, pgroupFocused, purItemEditors, grouping, ui,
          pgroupId, insertIndex);
    }

    List<Widget> flatOrGrouped() {
      return purchase.show_pgroup
          ? groupedEditors(
              grouping, purchase, ui, pgroupFocused, addPurItemDtoShort)
          : purItemEditors.value;
    }

    final storeFocusNode = useFocusNode(
      debugLabel: 'storeFocusNode',
    );

    if (purchase.purItems.isEmpty) {
      storeFocusNode.requestFocus();
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
                            // enableSuggestions: true,
                            minLines: 1,
                            maxLines: 3,
                            controller: titleInputCtrl,
                            autofocus: true,
                            focusNode: storeFocusNode,
                            onChanged: (String text) {
                              if (text.endsWith("\n")) {
                                StaticLogger.append('ENDS_WITH_NEWLINE: $text');
                                titleInputCtrl.text =
                                    text.substring(0, text.length - 1);
                                purItemEditors.value.first.focusNode
                                    .requestFocus();
                              } else {
                                purchase.name = text;
                              }
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
                    onPressed: onSaveButtonPressed,
                    child: const Icon(Icons.save,
                        size: sendMessageInputIconSize, color: Colors.white)),
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
                        ToggleText('Groups', purchase.show_pgroup,
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
                        ToggleText('Sequence', purchase.show_serno,
                            (bool newShowSerno) {
                          purchase.show_serno = newShowSerno;
                          ui.newPurchaseSettings.showSerno = newShowSerno;
                        }, ui),
                        ToggleIconText(iconByBought(BOUGHT_UNKNOWN),
                            'Waiting state', purchase.show_state_unknown,
                            (bool newShowThreeState) {
                          purchase.show_state_unknown = newShowThreeState;
                          ui.newPurchaseSettings.showStateUnknown =
                              newShowThreeState;
                        }, ui),
                        ToggleIconText(iconByBought(BOUGHT_STOP), 'Stop state',
                            purchase.show_state_stop, (bool newShowStateStop) {
                          purchase.show_state_stop = newShowStateStop;
                          ui.newPurchaseSettings.showStateStop =
                              newShowStateStop;
                        }, ui),
                        ToggleIconText(iconByBought(BOUGHT_QUESTION),
                            'Question state', purchase.show_state_question,
                            (bool newShowStateQuestion) {
                          purchase.show_state_question = newShowStateQuestion;
                          ui.newPurchaseSettings.showStateQuestion =
                              newShowStateQuestion;
                        }, ui),
                        ToggleIconText(iconByBought(BOUGHT_HALFODNE),
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
                                    onPressed: onCancelButtonPressed,
                                    child: const Icon(Icons.undo_rounded,
                                        color: Colors.white,
                                        size: sendMessageInputIconSize)),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: onSaveButtonPressed,
                                  child: const Icon(Icons.save,
                                      color: Colors.white,
                                      size: sendMessageInputIconSize)),
                            ]),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ToggleText('Quantity', purchase.show_qnty,
                                      (bool newShowQnty) {
                                    purchase.show_qnty = newShowQnty;
                                    ui.newPurchaseSettings.showQnty =
                                        newShowQnty;
                                  }, ui),
                                  ToggleText('Total', purchase.show_price,
                                      (bool newShowPrice) {
                                    purchase.show_price = newShowPrice;
                                    ui.newPurchaseSettings.showPrice =
                                        newShowPrice;
                                  }, ui),
                                  ToggleText('Weight', purchase.show_weight,
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
          if (purchase.show_pgroup) {
            grouping.deleteGroup(pgroupId);
            ui.rebuild();
          }
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
        onChange: (newName) {
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

int serno = 0;
PurchaseItemEdit createPurItemEditor(
    PurchaseDto purchase,
    PurItemDto purItem,
    ValueNotifier<int?> pgroupFocused,
    ValueNotifier<List<PurchaseItemEdit>> purItemEditors,
    ValueNotifier<Grouping> grouping,
    UiState ui,
    [bool autofocus = true]) {
  return PurchaseItemEdit(
    key: Key(
        '${serno++}:${purItem.id}:${purItem.pgroup_id}:${purItem.product_id}'),
    purchase: purchase,
    purItem: purItem,
    onTapNotifyFocused: () {
      pgroupFocused.value = null;
    },
    onChange: (newName) {
      final editingLastProduct = purchase.purItems.last == purItem;
      final noEmptyProduct = allPurItemsHaveName(purchase.purItems);
      if (editingLastProduct && noEmptyProduct) {
        addPurItemDto(
            purchase, pgroupFocused, purItemEditors, grouping, ui, null);
      }
      final editor =
          purItemEditors.value.firstWhere((x) => x.purItem == purItem);
      editor.focusNode.requestFocus();
    },
    canDelete: true,
    onDelete: () {
      purItemEditors.value.removeWhere((x) => x.purItem == purItem);
      ui.rebuild();
    },
    autofocus: autofocus,
    onEnter: () {
      // final editingLastProduct = purchase.purItems.last == purItem;
      // if (editingLastProduct) {
      //   if (purItem.name.isNotEmpty) {
      //     final lastEditor = purItemEditors.value.last;
      //     lastEditor.focusNode.requestFocus();
      //   }
      // } else {
      final myEditorIndex =
          purItemEditors.value.indexWhere((x) => x.purItem == purItem);
      final nextEditorIndex = myEditorIndex + 1;
      final outOfBounds = nextEditorIndex >= purItemEditors.value.length;
      if (!outOfBounds) {
        final nextEditor = purItemEditors.value[nextEditorIndex];
        if (nextEditor.purItem.name.isEmpty) {
          Future.delayed(const Duration(milliseconds: 100), () {
            nextEditor.focusNode.requestFocus();
          });
        } else {
          addPurItemDto(purchase, pgroupFocused, purItemEditors, grouping, ui,
              null, nextEditorIndex);
          final addedEditor = purItemEditors.value[nextEditorIndex];

          Future.delayed(const Duration(milliseconds: 200), () {
            addedEditor.focusNode.requestFocus();
          });
        }
        // } else {
        //   addPurItemDto(purchase, pgroupFocused, purItemEditors, grouping, ui,
        //       null, nextEditorIndex);
        //   final addedEditor = purItemEditors.value[nextEditorIndex];
      }
      // }
    },
    // autofocus: autofocus,
  );
}

addPurItemDto(
    PurchaseDto purchase,
    ValueNotifier<int?> pgroupFocused,
    ValueNotifier<List<PurchaseItemEdit>> purItemEditors,
    ValueNotifier<Grouping> grouping,
    UiState ui,
    int? pgroupId,
    [int? insertIndex]) {
  final newPurItem = PurItemDto(
    id: 0,
    bought: 0,
    name: '',
    pgroup_id: pgroupId,
  );

  final editor = createPurItemEditor(
      purchase, newPurItem, pgroupFocused, purItemEditors, grouping, ui);

  if (insertIndex != null && insertIndex < purchase.purItems.length - 1) {
    purchase.purItems.insert(insertIndex, newPurItem);
    purItemEditors.value.insert(insertIndex, editor);
  } else {
    purchase.purItems.add(newPurItem);
    purItemEditors.value.add(editor);
  }

  if (purchase.show_pgroup) {
    grouping.value.addProduct(newPurItem);
  }
  ui.rebuild(); //will add new field on type
}
