import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    /// initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text(
          "Chat App",
        ),
        actions: [
          /// search user button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

          /// more features button
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
        ],
      ),

      /// floating action button to add user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),

      body: ListView.builder(
          itemCount: 16,
          padding: EdgeInsets.only(top: mq.height * .02),
          physics:const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return const ChatUserCard();
          }),
    );
  }
}
