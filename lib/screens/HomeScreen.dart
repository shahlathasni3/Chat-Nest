import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> list = [];
  // for storing searched elements
  final List<ChatUser> SearchList = [];
  // for stoing search status
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: isSearching
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Name,Email..."),
                    autofocus: true,
                    style: TextStyle(fontSize: 17),
                    // when search text changes then updated search list
                    onChanged: (val){
                      // search logic
                      SearchList.clear();
                      val = val.toLowerCase();
                      for(var i in list){
                        if (i.name.toLowerCase().contains(val) ||
                        i.email.toLowerCase().contains(val)) {
                        SearchList.add(i);
                        }
                      }
                      setState(() => SearchList);
                    },
                  )
                : Text("Chat Nest"),
            actions: [
              // serach user button
              IconButton(
                  tooltip: 'Search',
                  onPressed: () => setState(() => isSearching = !isSearching),
                  icon: Icon(isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search)),

              // more features button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => profileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),

          // floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 15),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  // if sopme or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];


                    if (list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: isSearching ? SearchList.length : list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Cat_user_card(
                              user: isSearching ? SearchList[index]:list[index],
                            );
                          // return Text('Name:${list[index]}');
                          });
                    } else {
                      return Center(
                          child: Text(
                        "No connections found!",
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              },
          ),
        ),
      ),
    );
  }
}
