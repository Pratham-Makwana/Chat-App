import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../model/chat_user.dart';

/// profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

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
          title: const Text(
            "Chat App",
          ),
        ),

        /// floating action button to add user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              /// for showing progress dialog box
              Dialogs.showProgressBar(context);

              /// sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  /// for hiding process dialog
                  Navigator.pop(context);

                  /// for moving to home screen
                  Navigator.pop(context);

                  /// replacing home screen with login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                });
              });
            },
            label: const Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            icon: const Icon(
              Icons.login_outlined,
              color: Colors.white,
            ),
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.height * .03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// For adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  Stack(
                    children: [
                      /// profile picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          height: mq.height * .2,
                          width: mq.height * .2,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),

                      /// edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {},
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    ],
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
                    height: mq.height * .05,
                  ),

                  /// name input filed
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: const Text("Name"),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        )),
                  ),

                  /// For adding some space
                  SizedBox(
                    height: mq.height * .02,
                  ),

                  /// about input field
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: const Text("About"),
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.black,
                        )),
                  ),

                  /// For adding some space
                  SizedBox(
                    height: mq.height * .02,
                  ),

                  /// update profile button
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, mq.height * .06),
                          backgroundColor: Colors.deepPurple.shade500),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackBar(
                                context, "Profile Update Successfully");
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
