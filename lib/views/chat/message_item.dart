import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/network/incoming/incoming_state.dart';
import 'package:shopping_list_flutter/network/incoming/message_dto.dart';
import 'package:shopping_list_flutter/utils/timeago.dart';
import 'package:shopping_list_flutter/views/chat/purchase.dart';

class MessageItem extends ConsumerWidget {
  MessageDto message;
  final bool isMe;
  bool selected;
  bool dismissed;

  MessageItem({
    Key? key,
    required this.message,
    this.isMe = false,
    this.selected = false,
    this.dismissed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming = ref.watch(incomingStateProvider);

    final personReadStatus =
        '${message.persons_read.length} / ${incoming.currentRoom.users.length}';

    final int personsUnread =
        incoming.currentRoom.users.length - message.persons_read.length;
    final bool allParticipantsReceived = personsUnread == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              isMe ? 'Me' : message.user_name,
              style: GoogleFonts.manrope(
                  color: isMe ? Colors.grey : Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        (isMe ? Colors.white : Colors.black).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 5),
                  margin: (isMe
                      ? const EdgeInsets.fromLTRB(40, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(0, 0, 40, 0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      message.purchase != null
                          ? Purchase(
                              purchase: message.purchase!,
                            )
                          : Text(
                              message.content,
                              softWrap: true,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(isMe ? 1 : 0.8),
                                fontSize: 15,
                              ),
                            ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          allParticipantsReceived
                              ? const Icon(Icons.check_circle_rounded,
                                  color: Colors.grey, size: 15)
                              : const Icon(Icons.check_outlined,
                                  color: Colors.grey, size: 15),
                          const SizedBox(width: 5),
                          Text(
                            personReadStatus,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(isMe ? 1 : 0.8),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            message.edited ? 'edited' : '',
                            style: GoogleFonts.poppins(
                                color: Colors.yellowAccent
                                    .withOpacity(isMe ? 1 : 0.8),
                                fontSize: 10,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            message.edited
                                ? timeAgoSinceDate(message.date_updated)
                                : timeAgoSinceDate(message.date_created),
                            style: GoogleFonts.manrope(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
