import 'dart:math';

import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Handles google login button click
  _handleGoogleSignIn() {
    /// for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      /// for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      /// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /// Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      /// Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      /// Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackBar(context, "Something Went Wrong (Check Internet!)");
      return null;
    }
  }

  /// sign out function
  _signOut() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    //mq = MediaQuery.of(context).size;
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Chat App",
        ),
      ),

      /// Body
      body: Stack(
        children: [
          /// Image
          Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .50,
            child: Image.asset(
              'assets/images/talk.png',
            ),
          ),

          /// Google Sign In Button
          /// Button With The Image & Text
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .90,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleGoogleSignIn();
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: mq.height * .05,
              ),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "SignIn With Google",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
