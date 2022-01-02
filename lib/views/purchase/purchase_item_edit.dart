import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/pur_item_dto.dart';
import '../../network/incoming/purchase_dto.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';

class PurchaseItemEdit extends HookConsumerWidget {
  PurchaseDto purchase;
  PurItemDto purItem;
  bool isMe;

  PurchaseItemEdit({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final nameInputCtrl = useTextEditingController();
    nameInputCtrl.text = purItem.name;
    final ValueNotifier<num> qnty = useState(purItem.qnty ?? 0);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
            child: const Icon(Icons.drag_handle, color: Colors.blue, size: 20)),
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
                    decoration: InputDecoration(
                      hintText: 'Enter Product to Purchase...',
                      hintStyle: textInputHintStyle,
                      // border: InputBorder.none,
                      contentPadding: textInputPadding,
                    ),
                    style: textInputStyle))),
        const SizedBox(width: 10),
        IconButton(
            icon: const Icon(Icons.delete_outline_outlined,
                size: 24, color: Colors.blue),
            enableFeedback: true,
            autofocus: true,
            onPressed: () {
              purchase.purItems.remove(purItem);
              ui.rebuild();
            })
      ],
    );
  }
}
