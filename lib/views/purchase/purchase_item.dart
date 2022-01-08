import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';

class PurchaseItem extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final bool isMe;
  final Function() recalculateTotalsSendToServer;
  // final Function(PurchaseDto originalPurItem) purItemToggle;

  const PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.recalculateTotalsSendToServer,
    // required this.purItemToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);

    final qntyInputCtrl =
        useTextEditingController(text: purItem.bought_qnty?.toString() ?? '');
    // qntyInputCtrl.addListener(() {
    //   try {
    //     purItem.bought_qnty = double.parse(updateQnty.text);
    //   } catch (e) {}
    // });
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
    // priceInputCtrl.addListener(() {
    //   try {
    //     purItem.bought_price = double.parse(priceInputCtrl.text);
    //   } catch (e) {}
    // });
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
    // weightInputCtrl.addListener(() {
    //   try {
    //     purItem.bought_weight = double.parse(weightInputCtrl.text);
    //   } catch (e) {}
    // });
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
              // purItemToggle(purItem);
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
                  // purItemToggle(purItem);
                  recalculateTotalsSendToServer();
                },
                child:
                    Text(purItem.name, softWrap: true, style: purchaseStyle))),
        optionalNumberInput(
          purchase.show_qnty, qntyColumnWidth, qntyInputCtrl, 'Quantity',
          // (newDouble) {
          //   purItem.bought_qnty = newDouble;
          // }, purItemToggle
        ),
        optionalNumberInput(
          purchase.show_price, priceColumnWidth, priceInputCtrl, 'Price',
          // (newDouble) {
          //   purItem.bought_price = newDouble;
          // }, purItemToggle
        ),
        optionalNumberInput(
          purchase.show_weight, weightColumnWidth, weightInputCtrl, 'Weight',
          // (newDouble) {
          //   purItem.bought_weight = newDouble;
          // }, purItemToggle
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
                // onChanged: (String text) {
                //   pushToObject(double.parse(text));
                //   // ui.rebuild();
                //   // recalculateTotals();
                // },
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
