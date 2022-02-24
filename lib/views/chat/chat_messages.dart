import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../hooks/scroll_controller_for_animation.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/static_logger.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import '../../views/chat/message_item.dart';
import '../../widget/context_menu.dart';

class ChatMessages extends HookConsumerWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui =
        ref.watch(uiStateProvider); // DONT REMOVE, REFRESH ON PURCHASE SAVED
    final incoming = ref.watch(incomingStateProvider);

    incoming.outgoingHandlers.sendMarkMessagesRead();

    final tapGlobalPosition = useState(const Offset(0, 0));

    final hideFabAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    final scrollController =
        useScrollControllerForAnimation(hideFabAnimController);

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      itemCount: incoming.getMessageWidgets.length,
      itemBuilder: (BuildContext context, int index) {
        final MessageWidget msgWidget = incoming.getMessageWidgets[index];
        Widget dismissibleMsgWidget =
            makeDismissible(context, ref, incoming.getMessageWidgets, index);
        Widget ret = addLongTapSelection(
            dismissibleMsgWidget, msgWidget, ref, context, tapGlobalPosition);
        return ret;
      },
    );
  }

  Widget makeDismissible(BuildContext context, WidgetRef ref,
      List<MessageWidget> msgWidgets, index) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    final TextStyle dismissibleTextStyle = GoogleFonts.poppins(
      color: Colors.white.withOpacity(0.8),
      fontSize: 18,
    );

    final TextStyle snackBarDismissedTextStyle = GoogleFonts.poppins(
      color: Colors.red.withOpacity(0.8),
      fontSize: 18,
    );

    final msgWidget = msgWidgets[index];
    return Dismissible(
        // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify widgets.
        key: Key(msgWidget.message.id.toString()),
        secondaryBackground: Container(
          color: chatMessageReply,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Reply', style: dismissibleTextStyle),
            const SizedBox(width: 10),
            const Icon(
              Icons.reply_outlined,
              color: Colors.white,
            ),
          ]),
        ),
        background: Container(
          color: chatMessageDismiss,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text('Archive', style: dismissibleTextStyle),
          ]),
        ),
        confirmDismiss: (direction) async {
          switch (direction) {
            case DismissDirection.endToStart:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Floating REPLY_MESSAGE bar here',
                    style: snackBarDismissedTextStyle,
                  ),
                ],
              )));

              ui.isReplyingToMessageId = msgWidget.message.id;

              // HACK to reset ui.isReplyingToMessageId = NULL
              ui.messagesSelected.addAll({msgWidget.message.id: msgWidget});
              msgWidget.selected = true;

              ui.rebuild();
              //TODO popup soft keyboard to reply
              return false;
          }
          return true;
        },
        onDismissed: (direction) {
          switch (direction) {
            case DismissDirection.startToEnd:
              msgWidgets.removeAt(index);
              incoming.outgoingHandlers.sendArchiveMessages(
                  [msgWidget.message.id], incoming.personId, true);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Message archived',
                    style: snackBarDismissedTextStyle,
                  ),
                  const SizedBox(width: 40),
                  msgWidgets[index] != msgWidget
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            icon: const Icon(
                              Icons.undo_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              incoming.outgoingHandlers.sendArchiveMessages(
                                  [msgWidget.message.id],
                                  incoming.personId,
                                  false);

                              if (msgWidgets[index] != msgWidget) {
                                msgWidgets.insert(index, msgWidget);
                                ui.rebuild();
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Text('Undo', style: dismissibleTextStyle),
                          const SizedBox(width: 5),
                        ])
                      : Text('Message restored', style: dismissibleTextStyle),
                ],
              )));
              ui.rebuild();
              break;
          }
        },
        child: msgWidget);
  }

  Widget addLongTapSelection(
    Widget dismissibleMsgWidget,
    MessageWidget msgWidget,
    WidgetRef ref,
    BuildContext context,
    ValueNotifier<Offset> tapGlobalPosition,
  ) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);
    final messagesSelected = ui.messagesSelected;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails details) {
        tapGlobalPosition.value = details.globalPosition;
      },
      onTapUp: (TapUpDetails details) {
        if (msgWidget.selected) {
          messagesSelected.remove(msgWidget.message.id);
          msgWidget.selected = false;
          if (ui.msgInputCtrl.text == msgWidget.message.content) {
            ui.msgInputCtrl.text = '';
          }
          ui.isReplyingToMessageId = null;
        } else {
          // final inSelectionMode = messagesSelected.isNotEmpty;
          if (messagesSelected.isNotEmpty) {
            final first = messagesSelected.values.toList()[0];
            if (first.message.purchaseId != null) {
              messagesSelected.remove(first.message.id);
              first.selected = false;
            } else {
              messagesSelected.addAll({msgWidget.message.id: msgWidget});
              msgWidget.selected = true;
            }
          }
        }
        ui.rebuild();
      },
      onLongPress: () async {
        HapticFeedback.vibrate();

        MessageWidget? singlePrevSelected = messagesSelected.length == 1
            ? messagesSelected.values.toList()[0]
            : null;

        for (var eachSelected in messagesSelected.values) {
          eachSelected.selected = false;
          if (ui.msgInputCtrl.text == eachSelected.message.content) {
            ui.msgInputCtrl.text = '';
          }
        }
        messagesSelected.clear();

        if (singlePrevSelected == msgWidget) {
          ui.rebuild();
          return;
        }

        if (msgWidget.isMe &&
            msgWidget.message.purchaseId == null &&
            messagesSelected.isEmpty &&
            ui.msgInputCtrl.text == '') {
          ui.msgInputCtrl.text = msgWidget.message.content;
          incoming.isEditingMessageId = msgWidget.message.id;
          // TODO: open soft keyboard
        }

        messagesSelected.addAll({msgWidget.message.id: msgWidget});
        msgWidget.selected = true;

        ui.rebuild();

        if (!msgWidget.isMe && msgWidget.message.purchase == null) {
          await addPopupMenu(msgWidget, context, ref, tapGlobalPosition);
        }
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(
              //inSelectionMode ? 45 :
              16,
              16,
              16,
              16),
          color: msgWidget.selected ? chatMessageSelected : Colors.transparent,
          child: dismissibleMsgWidget),
    );
  }

  addPopupMenu(
    MessageWidget msgWidget,
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Offset> tapGlobalPosition,
  ) {
    final incoming = ref.watch(incomingStateProvider);
    final ui = ref.watch(uiStateProvider);
    final messagesSelected = ui.messagesSelected;

    final suffix =
        messagesSelected.length > 1 ? ' (${messagesSelected.length})' : '';

    final editCtx = CtxMenuItem(
      'Edit$suffix',
      () {
        StaticLogger.append('Edit$suffix');
      },
    );
    final archiveCtx = CtxMenuItem(
      'Archive$suffix',
      () {
        StaticLogger.append('Archive$suffix');
        incoming.outgoingHandlers.sendArchiveMessages(
            [msgWidget.message.id], incoming.personId, true);
      },
    );
    final replyCtx = CtxMenuItem(
      'Reply$suffix',
      () {
        StaticLogger.append('Reply$suffix');
      },
    );
    final forwardCtx = CtxMenuItem(
      'Forward$suffix',
      () {
        StaticLogger.append('Forward$suffix');
      },
    );
    final deleteCtx = CtxMenuItem(
      'Delete$suffix',
      () {
        StaticLogger.append('Delete$suffix');
        incoming.outgoingHandlers
            .sendDeleteMessages([msgWidget.message.id], incoming.personId);
      },
    );

    showPopupMenu(
        offset: tapGlobalPosition.value,
        context: context,
        ctxItems: [editCtx, archiveCtx, replyCtx, forwardCtx, deleteCtx]);
  }
}
