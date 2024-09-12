import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/helpers/dialogues.dart';
import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/screens/auth/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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

  String? images;

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
                  // user profile picture
                  Stack(
                    children: [
                      // profile picture
                      images != null ?
                          // local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height*.1),
                        child: Image.file(
                          File(images!),
                          width: mq.height*.2,
                          height: mq.height*.2,
                          fit: BoxFit.cover,
                      ),)

                      :

                      // image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height*.1),
                        child: CachedNetworkImage(
                          width: mq.height*.2,
                          height: mq.height*.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context,url,error)=>CircleAvatar(child: Icon(CupertinoIcons.person),),
                        ),),




                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(onPressed: (){
                            showBottomsheet();
                          },elevation: 1,color:Colors.white,child: Icon(Icons.edit,color: Colors.green,),shape: CircleBorder(),))

                    ]
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
                        APIs.updateUserInfo().then((value){
                          Dialogues.showSnackbar(context, "Profile updated successfully!");
                        });
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

  // bottom sheet for picking a profile picture for user
  void showBottomsheet(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: mq.height*.03,bottom: mq.height*.05),
          children: [
            Text('Pick Profile Picture.', textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            // buttons
            SizedBox(height: mq.height*.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // pick from gallery button
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                      if(image != null){
                        log('Image path : ${image.path} -- MimeType: ${image.mimeType}');

                        setState(() {
                          images = image.path;
                        });
                        // diding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder(), fixedSize: Size(mq.width*.3, mq.height*.15)),
                    child: Image.asset('images/addImage.png')
                ),
                // take picture from camera button
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.camera);

                      if(image != null){
                        log('Image path : ${image.path}');

                        setState(() {
                          images = image.path;
                        });
                        // diding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder(), fixedSize: Size(mq.width*.3, mq.height*.15)),
                    child: Image.asset('images/addCamera.jpg')
                ),
              ],
            )
          ],
        );
    });

  }
}
