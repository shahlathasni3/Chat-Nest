import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/models/message.dart';
import 'package:chat_nest/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';

  class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // for storing all messages
  List<Message> list = [];

  // for handling message text changes
  final textController = TextEditingController();
  // for storing value of showing or hiding emoji
  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() => showEmoji = !showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: appBar(),
            ),
          
            backgroundColor: Colors.blue.shade200,
            body: Column(children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                    // if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: SizedBox(),
                        );
                    // if sopme or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];
          
                        // final list = ["hii","heloo"];
                        if (list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return messageCard(message : list[index],);
                              });
                        } else {
                          return Center(
                              child: Text(
                                "Say Hiii! 👋",
                                style: TextStyle(fontSize: 20),
                              ));
                        }
                    }
                  },
                ),
              ),
              // chat input field
              ChatInput(),
              // show emojis on keyboard emoji button click and viseversa
              if(showEmoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      height: 256,
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 *(Platform.isIOS ?  1.20:  1.0),
                      ),
          
                    ),
                  ),
                ),
            ],),
          ),
        ),
      ),
    );
  }
  // appbar widget
  Widget appBar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          // back button
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.black54,)),
          // user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.3),
            child: CachedNetworkImage(
              width: mq.height*.055,
              height: mq.height*.055,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              Text(widget.user.name,style: TextStyle(fontSize: 16,color: Colors.black87,fontWeight: FontWeight.w500),),
              SizedBox(height: 2,),
              // last seen time of user
              Text("Last seen not available",style: TextStyle(fontSize: 13,color: Colors.black54,fontWeight: FontWeight.w500),)
          ],)
        ],
      ),
    );
  }
  // bottom chat inputField
  Widget ChatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height*.01,horizontal: mq.width*.025),
      child: Row(
        children: [
          // input field and butons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // emoji button
                  IconButton(onPressed: (){
                    FocusScope.of(context).unfocus();
                    setState(() => showEmoji = !showEmoji);
                  }, icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,size: 25,)),

                  Expanded(child: TextField( controller: textController,keyboardType: TextInputType.multiline, maxLines: null,onTap: (){
                    if(showEmoji)setState(() => showEmoji = !showEmoji);
                  },decoration: InputDecoration(hintText: 'type something...',hintStyle: TextStyle(color: Colors.blueAccent),border: InputBorder.none),)),
                  // pick image from gallery button
                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final List<XFile>? images =
                      await picker.pickMultiImage(imageQuality: 70);
                    for(var i in images!){   //=================================================*****may be remove ! after image =================================================*****
                      log('Image path : ${i.path}');
                      await APIs.sendChatImage(widget.user,File(i.path));
                    }
                  }, icon: Icon(Icons.image,color: Colors.blueAccent,size: 26,)),
                  // take image from camera button
                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);

                    if(image != null){
                      log('Image path : ${image.path}');

                      await APIs.sendChatImage(widget.user,File(image.path));
                    }
                  }, icon: Icon(Icons.camera_alt_rounded,color: Colors.blueAccent,size: 26,)),

                  SizedBox(width: mq.width*.02,)

                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(onPressed: (){
            if(textController.text.isNotEmpty){
              APIs.sendMessage(widget.user, textController.text, Type.text);
              textController.text = '';
            }
          },
            minWidth:0,
            padding: EdgeInsets.only(top: 10,bottom: 10,right: 5, left: 10),
            shape: CircleBorder(),
            color:Colors.green,
            child: Icon(Icons.send,color: Colors.white,size: 28,),),
        ],
      ),
    );
  }
}
