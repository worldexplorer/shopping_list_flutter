import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';

class PurchaseItem extends HookConsumerWidget {
  PurchaseDto purchase;
  PurItemDto purItem;
  bool isMe;
  Function() recalculateTotals;

  PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.recalculateTotals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final qntyInputCtrl = useTextEditingController();
    qntyInputCtrl.text = purItem.bought_qnty?.toString() ?? '';

    final priceInputCtrl = useTextEditingController();
    priceInputCtrl.text = purItem.bought_price?.toString() ?? '';

    final weightInputCtrl = useTextEditingController();
    weightInputCtrl.text = purItem.bought_weight?.toString() ?? '';

    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          purItem.bought = !purItem.bought;
          ui.rebuild();
        },
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            purItem.bought == true
                ? IconButton(
                    onPressed: () => purItem.bought = !purItem.bought,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.lightGreenAccent,
                      size: 20,
                    ))
                : IconButton(
                    onPressed: () => purItem.bought = !purItem.bought,
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.grey, size: 20)),
            const SizedBox(width: 3),
            Expanded(
                child:
                    Text(purItem.name, softWrap: true, style: purchaseStyle)),
            optionalNumberInput(
                purchase.show_qnty, qntyColumnWidth, qntyInputCtrl,
                (newDouble) {
              purItem.bought_qnty = newDouble;
            }, 'Quantity', recalculateTotals),
            optionalNumberInput(
                purchase.show_price, priceColumnWidth, priceInputCtrl,
                (newDouble) {
              purItem.bought_price = newDouble;
            }, 'Price', recalculateTotals),
            optionalNumberInput(
                purchase.show_weight, weightColumnWidth, weightInputCtrl,
                (newDouble) {
              purItem.bought_weight = newDouble;
            }, 'Weight', recalculateTotals),
          ],
        ));
  }

  optionalNumberInput(
      bool showNumberInput,
      double width,
      TextEditingController textInputCtrl,
      Function(double newDouble) setField,
      String hintText,
      Function() recalculateTotals,
      [UiState? ui]) {
    return showNumberInput
        ? Container(
            width: width,
            decoration: textInputDecoration,
            margin: textInputMargin,
            child: TextField(
                // textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.number,
                minLines: 1,
                maxLines: 1,
                controller: textInputCtrl,
                onChanged: (String text) {
                  setField(double.parse(text));
                  // ui.rebuild();
                  recalculateTotals();
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: textInputHintStyle,
                  // border: InputBorder.none,
                  contentPadding: textInputPadding,
                ),
                style: textInputStyle))
        : const SizedBox();
  }
}
