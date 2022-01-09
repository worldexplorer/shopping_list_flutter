import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/ui_state.dart';

import '../../network/incoming/purchase_dto.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/theme.dart';

import 'purchase_item.dart';

class Purchase extends HookConsumerWidget {
  final PurchaseDto purchase;
  final bool isMe;

  const Purchase({
    Key? key,
    required this.purchase,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    double tQnty = .0;
    double tPrice = .0;
    double tWeight = .0;

    recalculateTotals() {
      tQnty = .0;
      tPrice = .0;
      tWeight = .0;
      for (var purItem in purchase.purItems) {
        if (!purItem.bought) {
          continue;
        }
        tQnty += purItem.bought_qnty ?? 0.0;
        tPrice += purItem.bought_price ?? 0.0;
        tWeight += purItem.bought_weight ?? 0.0;
      }

      purchase.weight_total = tPrice;
      purchase.price_total = tWeight;
    }

    recalculateTotalsSendToServer() {
      // recalculateTotals();
      incoming.outgoingHandlers.sendFillPurchase(purchase);
      // ui.rebuild();
    }

    recalculateTotals();

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

          // ListView.builder(
          //   scrollDirection: Axis.vertical,
          //   shrinkWrap: true,
          //   itemCount: purchase.purItems.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final purItem = purchase.purItems[index];
          //     return PurchaseItem(
          //       purchase: purchase,
          //       purItem: purItem,
          //       isMe: isMe,
          //       recalculateTotalsSendToServer: recalculateTotalsSendToServer,
          //     );
          //   },
          // ),

          ...purchase.purItems.map((x) => PurchaseItem(
                key: Key('${x.id}:${DateTime.now().microsecond.toString()}'),
                purchase: purchase,
                purItem: x,
                isMe: isMe,
                recalculateTotalsSendToServer: recalculateTotalsSendToServer,
              )),

          if (purchase.show_qnty || purchase.show_price || purchase.show_weight)
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Total:', style: purchaseStyle),
                  const SizedBox(width: 30),
                  optionalTotal(
                      "Qnty", purchase.show_qnty, qntyColumnWidth, tQnty),
                  optionalTotal(
                      "Price", purchase.show_price, priceColumnWidth, tPrice),
                  optionalTotal("Weight", purchase.show_weight,
                      weightColumnWidth, tWeight),
                ]),
        ]);
  }

  optionalTotal(String hint, bool show, double columnWidth, double value) {
    Widget formatted = value == 0.0
        ? Text(hint, style: textInputHintStyle)
        : Text(value.toStringAsPrecision(3).toString(), style: purchaseStyle);
    return show
        ? Container(
            width: columnWidth,
            height: 40,
            decoration: textInputDecoration,
            margin: textInputMargin,
            padding: const EdgeInsets.all(10),
            child: formatted)
        : const SizedBox();
  }
}
