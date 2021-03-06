import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../network/incoming/incoming_state.dart';
import '../../network/incoming/message/message_dto.dart';
import '../../utils/ui_state.dart';
import '../../views/purchase/purchase.dart';
import '../../views/purchase/purchase_edit.dart';
import '../theme.dart';
import 'timeago.dart';

class MessageWidget extends ConsumerWidget {
  final MessageDto message;
  final bool isMe;
  bool selected;

  MessageWidget({
    Key? key,
    required this.message,
    this.isMe = false,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming = ref.watch(incomingStateProvider);

    final String personReadStatus =
        '${message.persons_read.length} / ${incoming.rooms.currentRoomUsersOrEmpty.length}';

    final int personsUnread = incoming.rooms.currentRoomUsersOrEmpty.length -
        message.persons_read.length;
    final bool allParticipantsReceived = personsUnread == 0;

    final ui = ref.watch(uiStateProvider);
    final inMessageEditMode = ui.isSingleSelected(message.id);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        !incoming.editingNewPurchase(this)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(isMe ? 'Me' : message.user_name,
                    style: messageUserStyle(isMe)),
              )
            : const SizedBox(height: 10),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: (isMe ? Colors.white : Colors.black).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 5),
                margin: (isMe
                    ? EdgeInsets.fromLTRB(
                        (message.purchase == null ? 40 : 0), 0, 0, 0)
                    : EdgeInsets.fromLTRB(
                        0, 0, (message.purchase == null ? 40 : 0), 0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    message.purchase != null
                        ? inMessageEditMode || incoming.editingNewPurchase(this)
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: PurchaseEdit(
                                  messageId: message.id,
                                  purchase: message.purchase!,
                                  // after SAVE, Purchase() will receive a new incoming...message.purchase
                                  purchaseClone: message.purchase!.clone(),
                                ))
                            : Purchase(
                                purchase: message.purchase!,
                              )
                        : Text(
                            message.content,
                            softWrap: true,
                            style: messageContentStyle(isMe),
                          ),
                    ...messageStatus(incoming.editingNewPurchase(this),
                        allParticipantsReceived, personReadStatus),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  List<Widget> messageStatus(bool editingNewPurchase,
      bool allParticipantsReceived, String personReadStatus) {
    if (editingNewPurchase) {
      return [];
    } else {
      return [
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            allParticipantsReceived
                ? const Icon(Icons.check_circle_rounded,
                    color: Colors.grey, size: 15)
                : const Icon(Icons.check_outlined,
                    color: Colors.grey, size: 15),
            const SizedBox(width: 5),
            Text(
              personReadStatus,
              style: messageReadStatusStyle(isMe),
            ),
            const SizedBox(width: 15),
            Text(
              message.edited ? 'edited' : '',
              style: messageEditedStyle(isMe),
            ),
            const SizedBox(width: 10),
            Text(
              message.edited
                  ? timeAgoSinceDate(message.date_updated)
                  : timeAgoSinceDate(message.date_created),
              style: messageTimeAgoStyle,
            ),
          ],
        )
      ];
    }
  }
}
