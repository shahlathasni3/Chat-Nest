import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/helpers/my_date_util.dart';
import 'package:chat_nest/models/chat_user.dart';
import 'package:chat_nest/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../screens/ChatScreen.dart';

class Cat_user_card extends StatefulWidget {
  final ChatUser user;
  const Cat_user_card({super.key, required this.user});

  @override
  State<Cat_user_card> createState() => _Cat_user_cardState();
}

class _Cat_user_cardState extends State<Cat_user_card> {

  // last message info(if null --> no message)
  Message? message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal:mq.width * .04,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.green.shade100,
      elevation: 0.5,
      child: InkWell(
        onTap: (){
          // navigate to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user,)));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context,snapshot){

              final data = snapshot.data?.docs;
              final list = data?.map((e) => Message.fromJson(e.data())).toList() ??
                  [];
              if(list.isNotEmpty) message = list[0];
              return ListTile(
                // user profile picture
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height*.3),
                  child: CachedNetworkImage(
                    width: mq.height*.055,
                    height: mq.height*.055,
                    imageUrl: widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                  ),
                ),
                // user name
                title: Text(widget.user.name),
                // user last message
                subtitle: Text(
                  message != null
                      ? message!.type == Type.image
                        ? 'image'
                        : message!.msg
                      : widget.user.about,
                  maxLines: 1,),
                // user last message time
                trailing: message == null
                    ? null //show nothing when no message is sent
                    : message!.read.isEmpty &&
                        message!.fromId != APIs.user.uid
                    ?
                    // show for unread message
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(color: Colors.greenAccent.shade400,borderRadius: BorderRadius.circular(10)),
                    )
                    :
                    // message sent time
                    Text(myDateUtil.getLastMessageTime(context: context, time: message!.sent),style: TextStyle(color: Colors.black54),),

              );
            })
      ),
    );
  }
}
