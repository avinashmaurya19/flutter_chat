import 'dart:developer';

import 'package:chatting_app/screens/auth/login_screen.dart';
import 'package:chatting_app/screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../api/apis.dart';

//splash screen --

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (Apis.auth.currentUser != null) {
        log('User: ${Apis.auth.currentUser}');
//navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }

      //navigate to home screen
    });
  }

  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to  We Chat'),
      ),
      body: Stack(
        //app logo
        children: [
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/chat.png'),
          ),

          // google login button
          Positioned(
              bottom: mq.height * .15,
              //left: mq.width * .05,
              width: mq.width,
              //height: mq.height * .06,
              child: Text(
                textAlign: TextAlign.center,
                'Made in India with ❤️',
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: .5),
              )),
        ],
      ),
    );
  }
}
