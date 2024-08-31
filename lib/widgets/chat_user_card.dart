import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/date_utill.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:chatapp/model/message.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  /// last message info ( if null --> no message)
  Message? _message = null;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      // color: Colors.deepPurple.shade100,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: mq.width * .025, vertical: 5),
      child: InkWell(
        onTap: () {
          /// for  navigate to chat screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = (snapshot.hasData) ? snapshot.data!.docs : [];

            // if (data != null && data.first.exists) {
            //   _message = Message.fromJson(data.first.data());
            // }

            final list = data.map((e) => Message.fromJson(e.data())).toList();

            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              /// User Profile Picture
              leading: InkWell(
                onTap: (){
                  showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .4),
                  child: CachedNetworkImage(
                    height: mq.height * .055,
                    width: mq.height * .055,
                    imageUrl: widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              /// User Name
              title: Text(widget.user.name),

              /// Last Message
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? 'Image'
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
              ),

              /// Last Message Time?
              trailing: _message == null
                  ? null

                  /// show nothing when no message sent
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid

                      /// show for unread message
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )

                      /// Message sent time
                      : Text(MyDateUtil.getLastMessageTime(
                          context: context, time: _message!.sent)),
              // trailing: const Text(
              //   "12.00 AM",
              //   style: TextStyle(color: Colors.black54),
              // ),
            );
          },
        ),
      ),
    );
  }
}
