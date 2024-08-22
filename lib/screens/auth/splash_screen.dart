import 'package:chatapp/main.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {

      if (FirebaseAuth.instance.currentUser != null) {
        /// navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        /// navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          /// Image
          Positioned(
            top: mq.height * .25,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset(
              'assets/images/chating.png',
            ),
          ),

          /// Text at Bottom
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                "MADE IN INDIA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 25,
                ),
              )),
        ],
      ),
    );
  }
}
