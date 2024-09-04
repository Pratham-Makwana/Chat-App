import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      /// exit full screen
      //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
      ));

      /// navigate to home screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => APIs.auth.currentUser != null
                  ? const HomeScreen()
                  : const LoginScreen()));
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
              "MADE IN INDIA WITH ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: .5,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
