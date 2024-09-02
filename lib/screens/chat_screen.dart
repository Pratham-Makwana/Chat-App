import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/date_util.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:chatapp/model/message.dart';
import 'package:chatapp/screens/view_profile_screen.dart';
import 'package:chatapp/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/apis.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /// for storing all message
  List<Message> _list = [];

  /// for handling message text changes
  final _textController = TextEditingController();

  /// for storing value of showing or hiding emoji
  bool _showEmoji = false;

  /// for checking if image is uploading or not?
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
    //     .copyWith(statusBarColor: Colors.transparent));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        /// emoji are shown  & back button pressed then hide emoji
        /// or else simple close current screen on back button click
        child: PopScope(
          canPop: _showEmoji ? false : true,
          onPopInvokedWithResult: (didPop, _) {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xffFFFFFF),

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
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        /// if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        /// if some or all data is loaded then shoe it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          //log('data ${jsonEncode(data![0].data())}');
                          _list = data!
                              .map((e) => Message.fromJson(e.data()))
                              .toList();

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .02),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                                //return Text('message : ${_list[index]}');
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

                /// progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(),
                      )),
                _chatInput(),

                /// showing emojis on keyboard emoji button click
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        //height: 256,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// app bar Widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
        stream: APIs.getUserinfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.hasData ? snapshot.data?.docs : [];
          final list = data!.map((e) => ChatUser.fromJson(e.data())).toList();
          return Row(
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
                  imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
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
                    list.isNotEmpty ? list[0].name : widget.user.name,
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
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive)
                        : MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: widget.user.lastActive),
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  /// bottom app input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  /// emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        //color: Colors.deepPurple,
                        size: 26,
                      )),

                  Expanded(
                      child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Message',
                        // hintStyle: TextStyle(color: Colors.deepPurple),
                        border: InputBorder.none),
                  )),

                  /// pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        /// Picking Multiple Images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        /// Uploading & Sending image one by one
                        for (var i in images) {
                          setState(() => _showEmoji = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _showEmoji = false);
                        }
                      },
                      icon: const Icon(
                        Icons.image_outlined,
                        //color: Colors.deepPurple,
                        size: 26,
                      )),

                  /// take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        /// Picks an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('image path ${image.path}');
                          setState(() => _showEmoji = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _showEmoji = false);
                        }
                      },
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

          const SizedBox(
            width: 5,
          ),

          /// send message button
          FloatingActionButton(
            backgroundColor: Colors.lightGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            child: const Icon(
              Icons.send,
              size: 24,
              color: Colors.white,
            ),
          )
          // MaterialButton(
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   onPressed: () {
          //     if (_textController.text.isNotEmpty) {
          //       APIs.sendMessage(widget.user, _textController.text);
          //       _textController.text = '';
          //     }
          //   },
          //   minWidth: 0,
          //   // padding:
          //   //     const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          //   shape: const CircleBorder(),
          //   color: Colors.green,
          //   child: const Icon(
          //     Icons.send,
          //     size: 24,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
