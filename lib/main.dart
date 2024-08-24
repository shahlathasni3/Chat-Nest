import 'package:chat_nest/screens/HomeScreen.dart';
import 'package:chat_nest/screens/auth/loginScreen.dart';
import 'package:flutter/material.dart';

// global object for accessing device screen size
late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Nest',
      theme: ThemeData(

        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20
          ),
          backgroundColor: Colors.white,
        ),
      ),
      home: loginScreen(),
    );
  }
}