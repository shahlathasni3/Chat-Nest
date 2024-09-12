import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Cat_user_card extends StatefulWidget {
  final ChatUser user;
  const Cat_user_card({super.key, required this.user});

  @override
  State<Cat_user_card> createState() => _Cat_user_cardState();
}

class _Cat_user_cardState extends State<Cat_user_card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal:mq.width * .04,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.green.shade100,
      elevation: 0.5,
      child: InkWell(
        onTap: (){},
        child: ListTile(
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
          subtitle: Text(widget.user.about,maxLines: 1,),
          // user last message time
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(color: Colors.greenAccent.shade400,borderRadius: BorderRadius.circular(10)),
          ),
          // trailing: Text("12:00 PM",style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}
