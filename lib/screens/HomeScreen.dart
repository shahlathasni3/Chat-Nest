import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text("Chat Nest"),
        actions: [
          // serach user button
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),

          // more features button
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
      ),

      // floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15,bottom: 15),
        child: FloatingActionButton(onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },child: Icon(Icons.add_comment_rounded),),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            final data = snapshot.data?.docs;
            log('Data : $data}');
          }
            return ListView.builder(
                itemCount: 17,
                padding: EdgeInsets.only(top: mq.height * .01),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return Cat_user_card();
                });
        }
      ),
    );
  }
}
