import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/theme.dart';
import '../../utils/ui_state.dart';

class PgroupEdit extends HookConsumerWidget {
  // final int id;
  final String name;
  final Function() onFocused;
  final Function(String newName) onChanged;
  final bool canDelete;
  final Function() onDelete;
  final hasDragHandle;

  const PgroupEdit({
    Key? key,
    // required this.id,
    required this.name,
    required this.onChanged,
    required this.canDelete,
    required this.onDelete,
    required this.onFocused,
    required this.hasDragHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final nameInputCtrl = useTextEditingController(text: name);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        hasDragHandle
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
                    onChanged: onChanged,
                    onTap: onFocused,
                    decoration: InputDecoration(
                      hintText: 'Group Name...',
                      hintStyle: textInputHintStyle,
                      // border: InputBorder.none,
                      contentPadding: textInputPadding,
                    ),
                    style: textInputStyle))),
        const SizedBox(width: 10),
        canDelete
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: iconSize,
                    icon: const Icon(Icons.delete_outline_outlined,
                        color: Colors.blue),
                    enableFeedback: true,
                    // autofocus: true,
                    onPressed: onDelete))
            : const SizedBox(width: iconSize),
      ],
    );
  }
}
