import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/helpers/dialogues.dart';
import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/screens/auth/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../main.dart';

// profile screen to show in signed in user information

class profileScreen extends StatefulWidget {

  final ChatUser user;

  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Screen"),
        ),
      
        // floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 15,bottom: 15),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red.shade400,
            onPressed: () async {
      
             Dialogues.showProgressBar(context);
             // for signout from app
             await APIs.auth.signOut().then((value) async {
               await GoogleSignIn().signOut().then((value){
                 // for hiding progress dialogue
                 Navigator.pop(context);
                 // for moving to home screeen
                 Navigator.pop(context);
                 // replace homescreen with login screen
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> loginScreen()));
               });
             });
      
          },icon: const Icon(Icons.logout),label: Text('Logout'),),
        ),
        body:Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width,height: mq.height*.03,),
                  
                  Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height*.1),
                            child: CachedNetworkImage(
                              width: mq.height*.2,
                              height: mq.height*.2,
                              fit: BoxFit.fill,
                              imageUrl: widget.user.image,
                              // placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: MaterialButton(onPressed: (){},elevation: 1,color:Colors.white,child: Icon(Icons.edit,color: Colors.green,),shape: CircleBorder(),))
                    
                        ]
                      ),
                      ],
                  ),
                  
                  SizedBox(height: mq.height*.03,),
                  // user email field
                  Text(widget.user.email,style: TextStyle(color: Colors.black54,fontSize: 17),),
                  SizedBox(height: mq.height*.05,),
                  // user name field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null: "Required field",
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,color: Colors.green,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg, happy sign',
                        label:Text('Name'),
                    ),
                  ),
                  SizedBox(height: mq.height*.02,),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null: "Required field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline,color: Colors.green,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg, Feeling Happy',
                      label:Text('About'),
                    ),
                  ),
                  SizedBox(height: mq.height*.05,),
                  // update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(mq.width*.5, mq.height*.055)),
                      onPressed: (){
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        log('Inside validator');
                      }
                      },
                      icon: Icon(Icons.edit,size: 27,),
                    label: Text("Update",style: TextStyle(fontSize: 17),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
