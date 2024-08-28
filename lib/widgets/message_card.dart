import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/model/message.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  /// sender or another user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                border: Border.all(color: const Color(0xFFCCCCCC)),
                borderRadius: const BorderRadius.only(
                  //topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: Text(widget.message.msg),
          ),
        ),

        /// message time
        Row(
          children: [
            /// read time
            Text(
              widget.message.sent,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),

            /// for adding some space
            const SizedBox(
              width: 3,
            ),

            /// double tick blue icon for message read
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),

            /// for adding some space
            SizedBox(
              width: mq.width * .04,
            ),
          ],
        ),
      ],
    );
  }

  /// our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// message time
        Row(
          children: [
            /// for adding some space
            SizedBox(
              width: mq.width * .04,
            ),

            /// double tick blue icon for message read
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),

            /// for adding some space
            const SizedBox(
              width: 3,
            ),

            /// read time
            Text(
              widget.message.sent,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        /// message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFDCF8C6),
                border: Border.all(color: const Color(0xFF34B759)),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  // topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: Text(widget.message.msg),
          ),
        ),
      ],
    );
    //#DCF8C6 for background
    // #34B759 border of green
  }
}
