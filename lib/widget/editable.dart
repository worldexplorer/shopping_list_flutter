import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../views/theme.dart';

class Editable extends HookWidget {
  final String text;
  final Widget child;
  final Function(String newText) onSubmitted;
  final Function()? onTap;
  final String hint;

  const Editable(
      {Key? key,
      required this.child,
      required this.text,
      required this.onSubmitted,
      this.onTap,
      this.hint = 'Enter...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputCtrl = TextEditingController(text: text);
    final isEditing = useState(false);
    final focusNode = useFocusNode(
      debugLabel: 'editableFocusNode',
    );

    return GestureDetector(
        onTap: onTap,
        onLongPressStart: (LongPressStartDetails details) {
          isEditing.value = true;
        },
        child: isEditing.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                    Flexible(
                      child: Container(
                          decoration: textInputDecoration,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: TextField(
                            autofocus: true,
                            focusNode: focusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 1,
                            onSubmitted: (modifiedText) {
                              isEditing.value = false;
                              onSubmitted(modifiedText);
                            },
                            controller: inputCtrl,
                            decoration: InputDecoration(
                              hintText: hint,
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.fromLTRB(
                                12.0,
                                0.0,
                                12.0,
                                0.0,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(
                        Icons.check,
                        size: editableInputIconSize,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        isEditing.value = false;
                        onSubmitted(inputCtrl.text);
                      },
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(
                        Icons.undo,
                        size: editableInputIconSize,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        isEditing.value = false;
                      },
                    )
                  ])
            : child);
  }
}
