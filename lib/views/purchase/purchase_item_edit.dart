import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../network/incoming/purchase/pur_item_dto.dart';
import '../../network/incoming/purchase/purchase_dto.dart';
import '../../utils/ui_state.dart';
import '../theme.dart';
import 'purchase_item.dart';

const ENTER_SYMBOL_TYPED = "\n";

class PurchaseItemEdit extends HookConsumerWidget {
  final PurchaseDto purchase;
  final PurItemDto purItem;
  final Function() onTapNotifyFocused;
  final Function(String newName) onChange;
  final bool canDelete;
  final Function() onDelete;
  final Function() onEnter;
  final bool autofocus;
  late FocusNode focusNode;

  PurchaseItemEdit({
    Key? key,
    required this.purchase,
    required this.purItem,
    required this.onTapNotifyFocused,
    required this.onChange,
    required this.canDelete,
    required this.onDelete,
    required this.onEnter,
    required this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final nameInputCtrl = useTextEditingController(text: purItem.name);

    focusNode = useFocusNode(
      debugLabel: 'PurchaseItemEdit key $key',
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // if (purItem.pgroup_id != null) const SizedBox(width: 25),
        if (purchase.show_pgroup) const SizedBox(width: 25),
        purchase.purItems.length > 1
            ? GestureDetector(
                onLongPressDown: (details) {
                  HapticFeedback.vibrate();
                },
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
                    enableSuggestions: true,
                    minLines: 1,
                    maxLines: 5,
                    controller: nameInputCtrl,
                    focusNode: focusNode,
                    autofocus: autofocus,
                    onChanged: (String text) {
                      if (text.contains(ENTER_SYMBOL_TYPED)) {
                        StaticLogger.append('ENDS_WITH_NEWLINE: $text');
                        nameInputCtrl.text =
                            text.replaceAll(ENTER_SYMBOL_TYPED, '');
                        onEnter();
                      } else {
                        purItem.name = text;
                        onChange(text);
                      }
                      ui.rebuild();
                    },
                    onTap: onTapNotifyFocused,
                    decoration: InputDecoration(
                      hintText: 'Product to purchase...',
                      hintStyle: textInputHintStyle,
                      // border: InputBorder.none,
                      contentPadding: textInputPadding,
                    ),
                    style: textInputStyle))),
        const SizedBox(width: 10),
        ...qntyColumns(purchase.show_qnty, purItem.qnty, purItem.punit_fpoint,
            purItem.punit_brief),
        canDelete
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: sendMessageInputIconSize,
                  icon: const Icon(Icons.delete_outline_outlined,
                      size: sendMessageInputIconSize, color: Colors.blue),
                  onPressed: () {
                    purchase.purItems.remove(purItem);
                    onDelete();
                    ui.rebuild();
                  },
                  enableFeedback: true,
                ))
            : const SizedBox(width: sendMessageInputIconSize),
      ],
    );
  }
}
