import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

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
        child: const ListTile(
          /// User Profile Picture
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),

          /// User Name
          title: Text("Demo User"),

          /// Last Message
          subtitle: Text(
            "Last Msg For a Day",
            maxLines: 1,
          ),

          /// Last Message Time?
          trailing: Text(
            "12.00 AM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
