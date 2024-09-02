import 'dart:developer';
import 'dart:io';

import 'package:chat_nest/helpers/dialogues.dart';
import 'package:chat_nest/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';
import '../../main.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  // Animation
  bool isAnimate = false;

  // Animation
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
     setState(() {
       isAnimate = true;
     });
    },);
    super.initState();
  }

  // handles google login btn click
  handleGooglebtnClick() {
    // for showing circular progressbar
    Dialogues.showProgressBar(context);
    signInWithGoogle().then((user){
      Navigator.pop(context);

      if(user != null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }

    });
  }
  Future<UserCredential?> signInWithGoogle() async {

   try{
     await InternetAddress.lookup('google.com');
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );

     // Once signed in, return the UserCredential
     return await APIs.auth.signInWithCredential(credential);
   }
   catch(e){
     log('\nsignInWithGoogle: $e');
     Dialogues.showSnackbar(context,'Something went wrong (Check internet!)');
     return null;
   }
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
          AnimatedPositioned(
            top: mq.height * .15,
            right: isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 2),
            child: Image.asset("images/icon.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child:ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                shape: StadiumBorder(),
                elevation: 1
              ),
              onPressed: (){
                handleGooglebtnClick();
              }, icon: Image.asset("images/google.png"),
              label: RichText(text: TextSpan(
                style: TextStyle(color: Colors.black,fontSize: 18),
                children: [
                TextSpan(text: "Login with "),
                TextSpan(text: "Google ",style: TextStyle(fontWeight: FontWeight.w700)),
              ],),),),
          ),
        ],
      ),
    );
  }
}
