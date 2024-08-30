import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  /// PopScope
  bool _canPop = true;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
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
        canPop: _isSearching ? false : true,
        onPopInvokedWithResult: (didPop,_){
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
          }
        },

        // WillPopScope(
        // onWillPop: () {
        //   if (_isSearching) {
        //     setState(() {
        //       _isSearching = !_isSearching;
        //     });
        //     return Future.value(false);
        //   } else {
        //     return Future.value(true);
        //   }
        // },
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
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),

          /// body
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
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
                  _list =
                      data!.map((e) => ChatUser.fromJson(e.data())).toList();

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mq.height * .02),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              _isSearching ? _searchList[index] : _list[index],
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
          ),
        ),
      ),
    );
  }
}
