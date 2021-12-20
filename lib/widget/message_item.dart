import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_flutter/network/common/message_dto.dart';
import 'package:shopping_list_flutter/utils/margin.dart';
import 'package:shopping_list_flutter/utils/timeago.dart';

class MessageItem extends StatelessWidget {
  final bool isMe;
  final MessageDto message;

  const MessageItem({
    Key? key,
    required this.message,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? 'Me' : message.user_name,
            style: GoogleFonts.manrope(
                color: isMe ? Colors.grey : Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          const YMargin(10),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: (isMe ? Colors.white : Colors.black).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    message.content,
                    style: GoogleFonts.poppins(
                      // NULL_ID__SERVER_SHOULD_ASSIGN
                      color: message.id == null
                          ? Colors.red.withOpacity(isMe ? 1 : 0.8)
                          : Colors.white.withOpacity(isMe ? 1 : 0.8),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const YMargin(3),
          Text(
            timeAgoSinceDate(message.date_created),
            style: GoogleFonts.manrope(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
