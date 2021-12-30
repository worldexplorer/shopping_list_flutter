import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';
import 'package:shopping_list_flutter/widget/context_menu.dart';
import 'package:shopping_list_flutter/views/chat/message_item.dart';

import '../../hooks/scroll_controller_for_animation.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/theme.dart';

class ChatMessages extends HookConsumerWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming = ref.watch(incomingStateProvider);

    final tapGlobalPosition = useState(const Offset(0, 0));
    final messagesSelected = useState<Map<int, MessageItem>>({});

    final hideFabAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    final scrollController =
        useScrollControllerForAnimation(hideFabAnimController);

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      itemCount: incoming.getMessageItems.length,
      itemBuilder: (BuildContext context, int index) {
        final msgItem = incoming.getMessageItems[index];
        Widget dismissibleMsgItem =
            makeDismissible(context, ref, incoming.getMessageItems, index);
        Widget ret = addContextMenu(context, dismissibleMsgItem, msgItem,
            messagesSelected, tapGlobalPosition);
        return ret;
      },
    );
  }

  Widget makeDismissible(
      BuildContext context, WidgetRef ref, List<MessageItem> items, index) {
    final ui = ref.watch(uiStateProvider);

    final TextStyle archiveTextStyle = GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.8),
      fontSize: 18,
    );

    final TextStyle snackBarDismissedTextStyle = GoogleFonts.poppins(
      color: Colors.red.withOpacity(0.8),
      fontSize: 18,
    );

    final msgItem = items[index];
    return Dismissible(
        // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets.
        key: Key(msgItem.message.id.toString()),
        background: Container(
          color: chatMessageDismiss,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Archive', style: archiveTextStyle),
            const SizedBox(width: 10),
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
          ]),
        ),
        onDismissed: (direction) {
          items.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Message archived',
                style: snackBarDismissedTextStyle,
              ),
              const SizedBox(width: 15),
              items[index] != msgItem
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(
                          Icons.undo_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (items[index] != msgItem) {
                            items.insert(index, msgItem);
                            ui.incrementRefreshCounter();
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Text('Undo', style: archiveTextStyle),
                      const SizedBox(width: 5),
                    ])
                  : Text('Message restored', style: archiveTextStyle),
              const SizedBox(width: 10),
            ],
          )));
        },
        child: msgItem);
  }

  Widget addContextMenu(
    BuildContext context,
    Widget dismissibleMsgItem,
    MessageItem msgItem,
    ValueNotifier<Map<int, MessageItem>> messagesSelected,
    ValueNotifier<Offset> tapGlobalPosition,
  ) {
    final TextStyle ctxMenuItemTextStyle = GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.8),
      fontSize: 15,
    );

    final editCtx = CtxMenuItem(
      'Edit',
      () {
        StaticLogger.clear();
      },
    );
    final archiveCtx = CtxMenuItem(
      'Archive',
      () {
        StaticLogger.clear();
      },
    );
    final replyCtx = CtxMenuItem(
      'Reply',
      () {
        StaticLogger.clear();
      },
    );
    final forwardCtx = CtxMenuItem(
      'Forward',
      () {
        StaticLogger.clear();
      },
    );
    final deleteCtx = CtxMenuItem(
      'Delete',
      () {
        StaticLogger.clear();
      },
    );

    final inSelectionMode = messagesSelected.value.isNotEmpty;
    return wrapWithContextMenu(
        child: Container(
            padding: EdgeInsets.fromLTRB(inSelectionMode ? 45 : 16, 16, 16, 16),
            color: msgItem.selected ? chatMessageSelected : Colors.transparent,
            child: dismissibleMsgItem),
        context: context,
        tapGlobalPosition: tapGlobalPosition,
        items: [editCtx, archiveCtx, replyCtx, forwardCtx, deleteCtx],
        textStyle: ctxMenuItemTextStyle,
        onItemTap: () {
          if (!inSelectionMode) {
            return;
          }

          if (msgItem.selected) {
            messagesSelected.value.remove(msgItem.message.id);
            msgItem.selected = false;
          } else {
            messagesSelected.value.addAll({msgItem.message.id: msgItem});
            msgItem.selected = true;
          }
        },
        onOpened: () {
          messagesSelected.value.addAll({msgItem.message.id: msgItem});
          msgItem.selected = true;
        },
        onClosed: () {});
  }
}
