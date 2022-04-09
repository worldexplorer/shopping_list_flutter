import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/purchase/pur_item_dto.dart';
import '../../network/incoming/purchase/purchase_dto.dart';
import '../../utils/theme.dart';
import 'puritem_states.dart';

class PurchaseItem extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final bool isMe;
  final int serno;
  final Function(PurItemDto purItemDto) fillPurItem;

  // static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  const PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
    required this.fillPurItem,
    required this.serno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ui = ref.watch(uiStateProvider);

    final qntyInputCtrl = useTextEditingController();

    final updateQnty = useValueListenable(qntyInputCtrl);
    useEffect(() {
      // qntyInputCtrl.text = updateQnty.text;
      purItem.bought_qnty_string = updateQnty.text;
      // fillPurItem(purItem);
    }, [updateQnty.text]);

    final priceInputCtrl =
        useTextEditingController(text: purItem.bought_price?.toString() ?? '');
    final updatePrice = useValueListenable(priceInputCtrl);
    useEffect(() {
      priceInputCtrl.text = updatePrice.text;
      final newDouble = double.tryParse(updatePrice.text);
      if (newDouble != null && purItem.bought_price != newDouble) {
        purItem.bought_price = newDouble;
        fillPurItem(purItem);
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
        fillPurItem(purItem);
      }
    }, [updateWeight.text]);

    onPurItemTap() {
      final prevBought = purItem.bought;
      final nextBought = cycle012345(
          prevBought,
          purchase.show_state_unknown,
          purchase.show_state_stop,
          purchase.show_state_halfdone,
          purchase.show_state_question);
      purItem.bought = nextBought;
      fillPurItem(purItem);
    }

    return
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5),
        //   child:
        Row(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (purchase.show_serno)
          SizedBox(
              width: 30,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text('$serno', style: sernoStyle),
              ))
        else if (purchase.show_pgroup)
          const SizedBox(width: 10),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                constraints: const BoxConstraints(),
                iconSize: 22,
                onPressed: onPurItemTap,
                icon: iconByBought(purItem.bought))),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: GestureDetector(
                    onLongPressDown: (details) {},
                    onTapUp: (details) {
                      onPurItemTap();
                    },
                    child: Text(purItem.name,
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
    )
        // )
        ;
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
