import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(  SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return SafeArea(

      child: Scaffold(
        /// app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar() ,
        ),

        body: Container(),
      ),
    );
  }

  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          /// back button
          IconButton(onPressed: ()=>
            Navigator.pop(context)
          , icon: const Icon(Icons.arrow_back)),
          /// user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .4),
            child: CachedNetworkImage(
              height: mq.height * .05,
              width: mq.height * .05,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(width: 10,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// user name
              Text(widget.user.name,style: const TextStyle(fontSize: 16,color: Colors.black87,fontWeight: FontWeight.w500),),
              /// for adding some space
              const SizedBox(height: 1,),
              /// last seen time of user
              const Text('Last Seen Not Available',style: TextStyle(fontSize: 13,color: Colors.black54),),
            ],
          )
        ],
      ),
    );
  }
}
