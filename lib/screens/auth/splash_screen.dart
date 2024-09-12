import 'dart:developer';

import 'package:chat_nest/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../api/apis.dart';
import '../../main.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      // exit fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      if(APIs.auth.currentUser != null){
        log('\nUser: ${APIs.auth.currentUser}');
        // navigate home screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
        // navigate login screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => loginScreen()));
      }

    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,// Remove back button
        leading: Icon(CupertinoIcons.home),
        title: Text("Chat Nest"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            right:  mq.width * .25,
            width: mq.width * .5,
            child: Image.asset("images/icon.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child:Text('Created by shahla 💚',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,letterSpacing: .5,color: Colors.black87),),
          ),
        ],
      ),
    );
  }
}
