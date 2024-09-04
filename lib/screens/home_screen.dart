import 'dart:developer';

import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../model/chat_user.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// for storing all users
  List<ChatUser> _list = [];

  /// for storing searched items
  final List<ChatUser> _searchList = [];

  /// for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    /// for updating user active  status according to lifecycle events
    /// resume -- active or online
    /// pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler(
      (message) {
        log('message $message');
        if (APIs.auth.currentUser != null) {
          if (message.toString().contains('resume')) {
            APIs.updateActiveStatus(true);
          }
          if (message.toString().contains('pause')) {
            APIs.updateActiveStatus(false);
          }
          if (message.toString().contains('inactive')) {
            APIs.updateActiveStatus(false);
          }
          if (message.toString().contains('detached')) {
            APIs.updateActiveStatus(false);
          }
        }

        return Future.value(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      /// for hiding keyboard when a tab is detected on screen
      onTap: () => Focus.of(context).unfocus(),

      /// if search is on & back button pressed then close search
      /// or else simple close current screen on back button click
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
            return;
          }

          /// some delay before pop
          Future.delayed(
              const Duration(milliseconds: 300), SystemNavigator.pop);
        },
        child: Scaffold(
          /// AppBar
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name, Email, ......",
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      /// search logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }

                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : const Text(
                    "Chat App",
                  ),
            actions: [
              /// search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              /// more features button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert_outlined))
            ],
          ),

          /// floating action button to add user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),

          /// body
          body: StreamBuilder(
            /// get id of  only know users
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                /// if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                /// if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    /// get only those user, who's ids are provided
                    stream: APIs.getAllUsers(
                        snapshot.data!.docs.map((e) => e.id).toList()),
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
                          _list = data!
                              .map((e) => ChatUser.fromJson(e.data()))
                              .toList();

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: mq.height * .02),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                  user: _isSearching
                                      ? _searchList[index]
                                      : _list[index],
                                );
                                //return Text('name : ${list[index]}');
                              },
                            );
                          } else {
                            return const Center(
                                child: Text(
                              "No Connection Found",
                              style: TextStyle(fontSize: 20),
                            ));
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add_alt,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                  Text(' Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              /// actions
              actions: [
                /// cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    )),

                /// Add button
                MaterialButton(
                    onPressed: () async {
                      /// hide alert dialog
                      Navigator.pop(context);
                      if (email.trim().isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackBar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    ))
              ],
            ));
  }
}
