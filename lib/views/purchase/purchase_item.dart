import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final int serno;
  final Function() recalculateTotalsSendToServer;

  const PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.recalculateTotalsSendToServer,
    required this.serno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);

    final qntyInputCtrl = useTextEditingController();
    double? bought_qnty = purItem.bought_qnty;
    if (bought_qnty != null) {
      qntyInputCtrl.text = (purItem.punit_fpoint ?? false)
          ? bought_qnty.toInt().toString()
          : bought_qnty.toStringAsPrecision(2);
    }
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

    String purItemName = purItem.name;
    if (purchase.show_serno) {
      purItemName = '${serno})   ' + purItemName;
    }

    onPurItemTap() {
      if (purchase.show_threestate) {
        // false => NULL => true
        if (purItem.bought == null) {
          purItem.bought = true;
        } else {
          if (purItem.bought == true) {
            purItem.bought = false;
          } else {
            purItem.bought = null;
          }
        }
      } else {
        bool nullMeansNo = purItem.bought == null ? false : purItem.bought!;
        purItem.bought = !nullMeansNo;
      }
      recalculateTotalsSendToServer();
    }

    return Row(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding:
                EdgeInsets.fromLTRB(purchase.show_pgroup ? 10 : 0, 0, 10, 0),
            child: IconButton(
                color: Colors.grey,
                padding: const EdgeInsets.all(0),
                // iconSize: 20,
                constraints: const BoxConstraints(maxHeight: 25),
                onPressed: onPurItemTap,
                icon: purItem.bought != null
                    ? purItem.bought! == true
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.lightGreenAccent,
                          )
                        : const Icon(Icons.check_circle_outline_rounded,
                            color: Colors.grey)
                    : const Icon(
                        Icons.query_builder,
                        color: Colors.yellowAccent,
                      ))),
        // const SizedBox(width: 3),
        Expanded(
            child: Container(
                // color: Colors.lightBlueAccent,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: GestureDetector(
                    // onLongPressDown: (details) {
                    //   HapticFeedback.vibrate();
                    //   HapticFeedback.vibrate();
                    // },
                    onTapUp: (details) => onPurItemTap,
                    child: Text(purItemName,
                        softWrap: true, style: purchaseStyle)))),
        ...qntyColumns(purchase.show_qnty, purItem.qnty, purItem.punit_fpoint,
            purItem.punit_brief),
        optionalNumberInput(
          purchase.show_qnty,
          qntyColumnWidth,
          qntyInputCtrl,
          'Qnty',
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
}

Widget optionalNumberInput(bool showNumberInput, double width,
    TextEditingController textInputCtrl, String hintText) {
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

List<Widget> qntyColumns(
    bool show_qnty, double? qnty, bool? punit_fpoint, String? punit_brief) {
  if (!show_qnty ||
      qnty == null ||
      punit_fpoint == null ||
      punit_brief == null) {
    return [];
  } else {
    return [
      const SizedBox(width: 3),
      Text(punit_fpoint ? qnty.toStringAsPrecision(2) : qnty.toInt().toString(),
          style: purchaseStyle),
      const SizedBox(width: 3),
      Text(punit_brief, style: purchaseStyle),
      const SizedBox(width: 3),
    ];
  }
}
