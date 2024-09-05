

import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/screens/profile_screen.dart';
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

  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("Chat Nest"),
        actions: [
          // serach user button
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),

          // more features button
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>profileScreen(user: APIs.me,)));
          }, icon: const Icon(Icons.more_vert)),
        ],
      ),

      // floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15,bottom: 15),
        child: FloatingActionButton(onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },child: const Icon(Icons.add_comment_rounded),),
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context , snapshot){

          switch(snapshot.connectionState){
            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator(),);
          // if sopme or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              // for(var i in data!){
              //   log('Data : ${jsonEncode(i.data())}');
              //   list.add(i.data()['name']);
              // }

            if(list.isNotEmpty){
              return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    return Cat_user_card(
                      user: list[index],
                    );
                    // return Text('name : ${list[index]}');
                  });
            }
            else{
              return Center(child: Text("No connections found!",style: TextStyle(fontSize: 20),));
            }
          }
          }

      ),
    );
  }
}
