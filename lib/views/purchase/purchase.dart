import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/purchase_dto.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import '../../utils/purchase_totals.dart';

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

    final totals = PurchaseTotals();
    totals.recalculateTotals(purchase);

    purchase.weight_total = totals.tPrice;
    purchase.price_total = totals.tWeight;

    recalculateTotalsSendToServer() {
      // recalculateTotals();
      incoming.outgoingHandlers.sendFillPurchase(purchase);
      // ui.rebuild();
    }

    int serno = 1;
    int purItemsChecked =
        purchase.purItems.where((x) => x.bought == true).length;

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
                serno: serno++,
              )),

          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Expanded(
                    child: purItemsChecked > 0
                        ? Text(
                            '$purItemsChecked / ${purchase.purItems.length} items checked',
                            softWrap: true,
                            style: totalsStyle)
                        : const Divider()),
                ...visualizeTotals(purchase, totals),
              ]),
        ]);
  }

  List<Widget> visualizeTotals(PurchaseDto purchase, PurchaseTotals totals) {
    if (purchase.show_qnty || purchase.show_price || purchase.show_weight) {
      return [
        Text('Total:', style: totalsStyle),
        const SizedBox(width: 30),
        optionalTotal(
            "Qnty", purchase.show_qnty, qntyColumnWidth, totals.tQnty),
        optionalTotal(
            "Price", purchase.show_price, priceColumnWidth, totals.tPrice),
        optionalTotal(
            "Weight", purchase.show_weight, weightColumnWidth, totals.tWeight),
      ];
    } else {
      return [];
    }
  }

  Widget optionalTotal(
      String hint, bool show, double columnWidth, double value) {
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
