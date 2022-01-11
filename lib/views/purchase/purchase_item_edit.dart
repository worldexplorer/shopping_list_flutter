import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import 'purchase_item.dart';

class PurchaseItemEdit extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final Function() onTap;
  final Function(String newName) onChanged;
  final Function() onDeleted;

  const PurchaseItemEdit({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.onTap,
    required this.onChanged,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final nameInputCtrl = useTextEditingController(text: purItem.name);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // if (purItem.pgroup_id != null) const SizedBox(width: 25),
        if (purchase.show_pgroup) const SizedBox(width: 25),
        purchase.purItems.length > 1
            ? GestureDetector(
                child:
                    const Icon(Icons.drag_handle, color: Colors.blue, size: 20))
            : const SizedBox(width: 20),
        const SizedBox(width: 10),
        Flexible(
            child: Container(
                decoration: textInputDecoration,
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: TextField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    controller: nameInputCtrl,
                    onChanged: (String text) {
                      purItem.name = text;
                      onChanged(text);
                      // ui.rebuild();
                    },
                    onTap: onTap,
                    decoration: InputDecoration(
                      hintText: 'Product to Purchase...',
                      hintStyle: textInputHintStyle,
                      // border: InputBorder.none,
                      contentPadding: textInputPadding,
                    ),
                    style: textInputStyle))),
        const SizedBox(width: 10),
        ...qntyColumns(purchase.show_qnty, purItem.qnty, purItem.punit_fpoint,
            purItem.punit_brief),
        IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.delete_outline_outlined,
                size: iconSize, color: Colors.blue),
            enableFeedback: true,
            // autofocus: true,
            onPressed: () {
              purchase.purItems.remove(purItem);
              onDeleted();
              ui.rebuild();
            })
      ],
    );
  }
}
