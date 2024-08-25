import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/model/chat_user.dart';
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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      // color: Colors.deepPurple.shade100,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: mq.width * .025,vertical: 5),
      child: InkWell(
        onTap: () {},
        child:  ListTile(
          /// User Profile Picture
         // leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .4),
            child: CachedNetworkImage(
              height: mq.height * .055,
              width:  mq.height * .055,
              imageUrl: widget.user.image,
             // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),

          /// User Name
          title: Text(widget.user.name),

          /// Last Message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          /// Last Message Time?
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          // trailing: const Text(
          //   "12.00 AM",
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}
