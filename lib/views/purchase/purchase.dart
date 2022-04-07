import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/purchase/pur_item_dto.dart';
import '../../network/incoming/purchase/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import 'grouping.dart';
import 'purchase_item.dart';
import 'purchase_totals.dart';

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

    final grouping = useState(Grouping(purchase.purItems));

    final totals = PurchaseTotals();
    totals.recalculateTotals(purchase);

    purchase.weight_total = totals.tPrice;
    purchase.price_total = totals.tWeight;

    fillPurItem(PurItemDto purItemDto) {
      incoming.outgoingHandlers.sendFillPurItem(purItemDto, purchase);
      ui.rebuild();
    }

    int purItemsCheckedCounter =
        purchase.purItems.where((x) => x.bought == BOUGHT_CHECKED).length;

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
          ...flatOrGrouped(grouping, purchase, fillPurItem),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Text(
                        '$purItemsCheckedCounter / ${purchase.purItems.length} items checked',
                        softWrap: true,
                        style: purItemsCheckedCounter > 0
                            ? totalsStyleGreen
                            : totalsStyleGray)),
                const Spacer(),
                ...visualizeTotals(purchase, totals),
              ]),
        ]);
  }

  List<Widget> visualizeTotals(PurchaseDto purchase, PurchaseTotals totals) {
    if (purchase.show_qnty || purchase.show_price || purchase.show_weight) {
      return [
        Text('Total:', style: totalsStyleGreen),
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

  Iterable<Widget> flatOrGrouped(ValueNotifier<Grouping> groupingNotifier,
      PurchaseDto purchase, Function(PurItemDto purItemDto) fillPurItem) {
    int serno = 1;

    if (purchase.show_pgroup) {
      final grouping = groupingNotifier.value;

      final List<Widget> ret = [];

      int indexPgroup = 0;
      for (MapEntry<int, String> idPgroup in grouping.pgroupById.entries) {
        final int pgroupId = idPgroup.key;
        final String pgroupName = idPgroup.value;

        String pgroupCounters = pgroupName;
        final purItems = grouping.productsByPgroup[pgroupId] ?? [];
        // if (products.isNotEmpty) {
        //   pgroupCounters += ' (${products.length})';
        // }

        ret.add(Text(pgroupCounters, softWrap: true, style: pGroupStyle));

        int indexProduct = 0;
        for (PurItemDto purItem in purItems) {
          ret.add(PurchaseItem(
            key: Key(
                '$indexPgroup:$pgroupId:${indexProduct++}:${purItem.product_id}'),
            purchase: purchase,
            purItem: purItem,
            isMe: isMe,
            fillPurItem: fillPurItem,
            serno: serno++,
          ));
        }
      }
      return ret;
    } else {
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

      int i = 1;
      return purchase.purItems.map((purItem) => PurchaseItem(
            key: Key(
                '${i++}:${purItem.id}:${purItem.pgroup_id}:${purItem.product_id}'),
            purchase: purchase,
            purItem: purItem,
            isMe: isMe,
            fillPurItem: fillPurItem,
            serno: serno++,
          ));
    }
  }
}
