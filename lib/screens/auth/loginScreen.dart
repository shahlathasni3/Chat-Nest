import 'package:chat_nest/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
