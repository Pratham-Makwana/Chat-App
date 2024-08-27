import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../apis/apis.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return SafeArea(
      child: Scaffold(
        /// app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        /// body
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    /// if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                    /// if some or all data is loaded then shoe it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      log('data ${jsonEncode(data![0].data())}');
                      // _list =
                      //     data!.map((e) => ChatUser.fromJson(e.data())).toList();
                      final _list = ['hiii', 'hello'];
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * .02),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            // return ChatUserCard(
                            //   user: _isSearching
                            //       ? _searchList[index]
                            //       : _list[index],
                            // );
                            return Text('message : ${_list[index]}');
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                          "Say Hi !! 👋",
                          style: TextStyle(fontSize: 20),
                        ));
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  /// app bar Widget
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          /// back button
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),

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
          const SizedBox(
            width: 10,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// user name
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),

              /// for adding some space
              const SizedBox(
                height: 1,
              ),

              /// last seen time of user
              const Text(
                'Last Seen Not Available',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// bottom app input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  /// emoji button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        //color: Colors.deepPurple,
                        size: 26,
                      )),

                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Message',
                        // hintStyle: TextStyle(color: Colors.deepPurple),
                        border: InputBorder.none),
                  )),

                  /// pick image from gallery button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image_outlined,
                        //color: Colors.deepPurple,
                        size: 26,
                      )),

                  /// take image from camera button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        // color: Colors.deepPurple,
                        size: 26,
                      )),

                  /// adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          /// send message button
          MaterialButton(
            onPressed: () {},
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              size: 28,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
