import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';

class PurchaseItem extends HookConsumerWidget {
  PurchaseDto purchase;
  PurItemDto purItem;
  bool isMe;

  PurchaseItem({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> bought = useState(false);

    final qntyInputCtrl = useTextEditingController();
    final priceInputCtrl = useTextEditingController();
    final weightInputCtrl = useTextEditingController();

    return GestureDetector(
        onTapDown: (TapDownDetails details) => bought.value = !bought.value,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            bought.value == true
                ? IconButton(
                    onPressed: () => bought.value = !bought.value,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.lightGreenAccent,
                      size: 20,
                    ))
                : IconButton(
                    onPressed: () => bought.value = !bought.value,
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.grey, size: 20)),
            const SizedBox(width: 3),
            Expanded(
                child:
                    Text(purItem.name, softWrap: true, style: purchaseStyle)),
            purchase.show_qnty == 1
                ? Container(
                    width: qntyColumnWidth,
                    decoration: textInputDecoration,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: TextField(
                        // textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        maxLines: 1,
                        controller: qntyInputCtrl,
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                          hintStyle: textInputHintStyle,
                          // border: InputBorder.none,
                          contentPadding: textInputPadding,
                        ),
                        style: textInputStyle))
                : const SizedBox(),
            purchase.show_price == 1
                ? Container(
                    width: priceColumnWidth,
                    decoration: textInputDecoration,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: TextField(
                        // textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        maxLines: 1,
                        controller: priceInputCtrl,
                        decoration: InputDecoration(
                          hintText: 'Price',
                          hintStyle: textInputHintStyle,
                          // border: InputBorder.none,
                          contentPadding: textInputPadding,
                        ),
                        style: textInputStyle))
                : const SizedBox(),
            purchase.show_weight == 1
                ? Container(
                    width: weightColumnWidth,
                    decoration: textInputDecoration,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: TextField(
                        // textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        maxLines: 1,
                        controller: weightInputCtrl,
                        decoration: InputDecoration(
                          hintText: 'Weight',
                          hintStyle: textInputHintStyle,
                          // border: InputBorder.none,
                          contentPadding: textInputPadding,
                        ),
                        style: textInputStyle))
                : const SizedBox(),
          ],
        ));
  }
}
