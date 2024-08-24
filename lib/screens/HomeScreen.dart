import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: FloatingActionButton(onPressed: (){},child: Icon(Icons.add_comment_rounded),),
      ),
    );
  }
}
