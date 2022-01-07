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
  Function() recalculateTotalsSendToServer;

  PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.recalculateTotalsSendToServer,
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

    purItemToggle() {
      purItem.bought = !purItem.bought;
      ui.rebuild();
      debugPrint(
          'new bought: ${purItem.bought} for purItem[${purItem.id}:${purItem.name}] ');
      recalculateTotalsSendToServer();
    }

    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: purItemToggle,
            icon: purItem.bought
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.lightGreenAccent,
                    size: 20,
                  )
                : const Icon(Icons.check_circle_outline_rounded,
                    color: Colors.grey, size: 20)),
        const SizedBox(width: 3),
        Expanded(
            child: GestureDetector(
                onTapDown: (details) {
                  purItemToggle();
                },
                child:
                    Text(purItem.name, softWrap: true, style: purchaseStyle))),
        optionalNumberInput(purchase.show_qnty, qntyColumnWidth, qntyInputCtrl,
            (newDouble) {
          purItem.bought_qnty = newDouble;
        }, 'Quantity', recalculateTotalsSendToServer),
        optionalNumberInput(
            purchase.show_price, priceColumnWidth, priceInputCtrl, (newDouble) {
          purItem.bought_price = newDouble;
        }, 'Price', recalculateTotalsSendToServer),
        optionalNumberInput(
            purchase.show_weight, weightColumnWidth, weightInputCtrl,
            (newDouble) {
          purItem.bought_weight = newDouble;
        }, 'Weight', recalculateTotalsSendToServer),
      ],
    );
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
