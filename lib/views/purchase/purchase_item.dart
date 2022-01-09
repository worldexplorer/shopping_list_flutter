import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';

class PurchaseItem extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final bool isMe;
  final Function() recalculateTotalsSendToServer;

  const PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.recalculateTotalsSendToServer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);

    final qntyInputCtrl =
        useTextEditingController(text: purItem.bought_qnty?.toString() ?? '');
    final updateQnty = useValueListenable(qntyInputCtrl);
    useEffect(() {
      qntyInputCtrl.text = updateQnty.text;
      final newDouble = double.tryParse(updateQnty.text);
      if (newDouble != null && purItem.bought_qnty != newDouble) {
        purItem.bought_qnty = newDouble;
        recalculateTotalsSendToServer();
      }
    }, [updateQnty.text]);

    final priceInputCtrl =
        useTextEditingController(text: purItem.bought_price?.toString() ?? '');
    final updatePrice = useValueListenable(priceInputCtrl);
    useEffect(() {
      priceInputCtrl.text = updatePrice.text;
      final newDouble = double.tryParse(updatePrice.text);
      if (newDouble != null && purItem.bought_price != newDouble) {
        purItem.bought_price = newDouble;
        recalculateTotalsSendToServer();
      }
    }, [updatePrice.text]);

    final weightInputCtrl =
        useTextEditingController(text: purItem.bought_weight?.toString() ?? '');
    final updateWeight = useValueListenable(weightInputCtrl);
    useEffect(() {
      weightInputCtrl.text = updateWeight.text;
      final newDouble = double.tryParse(updateWeight.text);
      if (newDouble != null && purItem.bought_weight != newDouble) {
        purItem.bought_weight = newDouble;
        recalculateTotalsSendToServer();
      }
    }, [updateWeight.text]);

    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              purItem.bought = !purItem.bought;
              recalculateTotalsSendToServer();
            },
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
                  purItem.bought = !purItem.bought;
                  recalculateTotalsSendToServer();
                },
                child:
                    Text(purItem.name, softWrap: true, style: purchaseStyle))),
        optionalNumberInput(
          purchase.show_qnty,
          qntyColumnWidth,
          qntyInputCtrl,
          'Quantity',
        ),
        optionalNumberInput(
          purchase.show_price,
          priceColumnWidth,
          priceInputCtrl,
          'Price',
        ),
        optionalNumberInput(
          purchase.show_weight,
          weightColumnWidth,
          weightInputCtrl,
          'Weight',
        ),
      ],
    );
  }

  optionalNumberInput(bool showNumberInput, double width,
      TextEditingController textInputCtrl, String hintText,
      [Function(double newDouble)? pushToObject,
      Function()? recalculateTotals,
      UiState? ui]) {
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
