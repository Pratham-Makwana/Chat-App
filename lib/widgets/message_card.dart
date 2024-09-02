import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/model/message.dart';
import 'package:flutter/material.dart';

import '../helper/date_util.dart';
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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  /// sender or another user message
  Widget _blueMessage() {
    ///update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .02
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                border: Border.all(color: const Color(0xFFCCCCCC)),

                /// making border curved
                borderRadius: const BorderRadius.only(
                  //topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: widget.message.type == Type.text

                /// show text
                ? Text(widget.message.msg)

                /// show images
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        /// message time
        Row(
          children: [
            /// read time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              //widget.message.sent.substring(0, 5),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),

            /// for adding some space
            const SizedBox(
              width: 3,
            ),

            /// double tick blue icon for message read
            // const Icon(
            //   Icons.done_all_rounded,
            //   color: Colors.blue,
            //   size: 20,
            // ),

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

            ///double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            // Icon(
            //     widget.message.read.isNotEmpty
            //         ? Icons.done_all_rounded
            //         : Icons.done_all_rounded,
            //     color: widget.message.read.isNotEmpty
            //         ? Colors.blue
            //         : Colors.black54,
            //     size: 20),

            /// for adding some space
            const SizedBox(
              width: 3,
            ),

            /// send time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              //widget.message.sent.substring(0, 5),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        /// message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .01
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFDCF8C6),
                border: Border.all(color: const Color(0xFFDCF8C6)),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  // topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            child: widget.message.type == Type.text

                /// show text
                ? Text(widget.message.msg)

                /// show images
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            /// shrinkWrap show Listview  according to content
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
              ),

              /// copy option
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.deepPurple,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTab: () {})
                  : _OptionItem(
                      icon: const Icon(
                        Icons.download_for_offline_outlined,
                        color: Colors.deepPurple,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTab: () {}),

              /// Divider or Separator
              if (isMe)
                Divider(
                  color: Colors.black54,
                  indent: mq.width * .04,
                  endIndent: mq.width * .04,
                ),
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTab: () {}),

              if (isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    name: 'Delete Message',
                    onTab: () {}),

              /// Divider or Separator
              Divider(
                color: Colors.black54,
                indent: mq.width * .04,
                endIndent: mq.width * .04,
              ),

              _OptionItem(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                  name: 'Send At: ',
                  onTab: () {}),

              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.black,
                  ),
                  name: 'Read At: ',
                  onTab: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTab;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTab(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .02),
        child: Row(
          children: [
            icon,
            Text(
              '   $name',
              style: const TextStyle(
                  color: Colors.black87, fontSize: 16, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
