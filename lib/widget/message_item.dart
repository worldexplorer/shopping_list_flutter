import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_flutter/network/incoming/message_dto.dart';
import 'package:shopping_list_flutter/utils/timeago.dart';

class MessageItem extends StatelessWidget {
  final bool isMe;
  MessageDto message;

  MessageItem({
    Key? key,
    required this.message,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Text(
              isMe ? 'Me' : message.user_name,
              style: GoogleFonts.manrope(
                  color: isMe ? Colors.grey : Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 5),
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
                  padding: const EdgeInsets.all(10),
                  margin: (isMe
                      ? const EdgeInsets.fromLTRB(40, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(0, 0, 40, 0)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.edited
                            ? '* ${message.content}'
                            : message.content,
                        softWrap: true,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(isMe ? 1 : 0.8),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        timeAgoSinceDate(message.date_created),
                        style: GoogleFonts.manrope(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w300),
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
