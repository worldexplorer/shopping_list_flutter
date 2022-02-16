import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';

class PurchaseItem extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final bool isMe;
  final int serno;
  final Function(PurItemDto purItemDto) fillPurItem;

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
        fillPurItem(purItem);
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
      final nextBought = cycle0123(
          prevBought, purchase.show_state_unknown, purchase.show_state_stop);
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

  Icon iconByBought(int bought) {
    switch (bought) {
      case BOUGHT_CHECKED:
        return const Icon(
          Icons.check_circle,
          color: Colors.lightGreenAccent,
        );

      case BOUGHT_UNKNOWN:
        return const Icon(
          Icons.query_builder,
          color: Colors.yellowAccent,
        );

      case BOUGHT_STOP:
        return const Icon(
          Icons.stop_circle_outlined,
          color: Colors.red,
        );

      case BOUGHT_UNCHECKED:
      default:
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.grey,
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

const int BOUGHT_UNCHECKED = 0;
const int BOUGHT_CHECKED = 1;
const int BOUGHT_UNKNOWN = 2;
const int BOUGHT_STOP = 3;

int cycle0123(int current, bool show_unknown, bool show_stop) {
  // 0:unchecked => 1:checked => 2:unknown => 3:stop => 0
  switch (current) {
    case BOUGHT_UNCHECKED:
      return BOUGHT_CHECKED;

    case BOUGHT_CHECKED:
      if (show_unknown) {
        return BOUGHT_UNKNOWN;
      }
      if (show_stop) {
        return BOUGHT_STOP;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_UNKNOWN:
      if (show_stop) {
        return BOUGHT_STOP;
      }
      return BOUGHT_UNCHECKED;

    case BOUGHT_STOP:
      return BOUGHT_UNCHECKED;
  }

  return BOUGHT_UNCHECKED;
}

int cycle0231(current, bool show_unknown, bool show_stop) {
  // 0:unchecked => 2:unknown => 3:stop => 1:checked => 0
  switch (current) {
    case BOUGHT_UNCHECKED:
      if (show_unknown) {
        return BOUGHT_UNKNOWN;
      }
      if (show_stop) {
        return BOUGHT_STOP;
      }
      return BOUGHT_CHECKED;

    case BOUGHT_UNKNOWN:
      if (show_stop) {
        return BOUGHT_STOP;
      }
      return BOUGHT_CHECKED;

    case BOUGHT_STOP:
      return BOUGHT_CHECKED;

    case BOUGHT_CHECKED:
      return BOUGHT_UNCHECKED;
  }
  return BOUGHT_UNCHECKED;
}
