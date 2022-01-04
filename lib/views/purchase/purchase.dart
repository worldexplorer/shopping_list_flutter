import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';

import 'purchase_item.dart';

class Purchase extends HookConsumerWidget {
  PurchaseDto purchase;
  final bool isMe;

  Purchase({
    Key? key,
    required this.purchase,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double totalQnty = 0;
    double totalPrice = 0;
    double totalWeight = 0;
    for (var purItem in purchase.purItems) {
      totalQnty += purItem.bought_qnty ?? 0.0;
      totalPrice += purItem.bought_price ?? 0.0;
      totalWeight += purItem.bought_weight ?? 0.0;
    }

    return Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(purchase.name,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(isMe ? 1 : 0.8),
                fontSize: 15,
              )),

          ...purchase.purItems.map((x) => PurchaseItem(
                purchase: purchase,
                purItem: x,
                isMe: isMe,
              )),

          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Total:', style: purchaseStyle),
                const SizedBox(width: 30),
                optionalTotal(purchase.show_qnty, qntyColumnWidth, totalQnty),
                optionalTotal(
                    purchase.show_price, priceColumnWidth, totalPrice),
                optionalTotal(
                    purchase.show_weight, weightColumnWidth, totalWeight),
              ]),

          // ListView.builder(
          //   // scrollDirection: Axis.,
          //   // shrinkWrap: true,
          //   // padding: const EdgeInsets.all(10),
          //   itemCount: purchase.purItems.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final purItem = purchase.purItems[index];
          //     return PurchaseItem(
          //       purchase: purchase,
          //       purItem: purItem,
          //       isMe: isMe,
          //     );
          //   },
          // ),
        ]);
  }

  optionalTotal(bool show, double columnWidth, double value) {
    return show
        ? Container(
            width: columnWidth,
            height: 40,
            decoration: textInputDecoration,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            padding: const EdgeInsets.all(10),
            child: Text(value.toString(), style: purchaseStyle))
        : const SizedBox();
  }
}
