import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/date_utill.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../model/chat_user.dart';

/// view profile screen -- to view profile of the user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    /// initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      /// for hiding keyboard anywhere you click on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        /// AppBar
        appBar: AppBar(
          title: Text(
            widget.user.name,
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'About: ',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            Text(
              MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            )
          ],
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.height * .03),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// For adding some space
                SizedBox(
                  width: mq.width,
                  height: mq.height * .05,
                ),

                /// user profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .2,
                    width: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                /// For adding some space
                SizedBox(
                  height: mq.height * .03,
                ),

                /// user email label
                Text(
                  widget.user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),

                /// For adding some space
                SizedBox(
                  height: mq.height * .02,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    Text(
                      widget.user.about,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
