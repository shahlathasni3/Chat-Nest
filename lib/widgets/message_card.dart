import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_nest/api/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/my_date_util.dart';
import '../main.dart';
import '../models/message.dart';

class messageCard extends StatefulWidget {
  const messageCard({super.key, required this.message});

  final Message message;

  @override
  State<messageCard> createState() => _messageCardState();
}

class _messageCardState extends State<messageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? greenMessage()
        : blueMessage();
  }

  // sender or another user message
  Widget blueMessage(){

    // update last read message  if sender and reciever are different
    if(widget.message.read.isEmpty){
      APIs.updateReadMessageStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height* 0.01),
            decoration: BoxDecoration(color: Colors.blue.shade300,border: Border.all(color: Colors.lightBlue),borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30))),
            child:
                widget.message.type == Type.text
                ?
                // show text
                Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87),
                )
                 :
                // show image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.msg,
                    placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
                    errorWidget: (context, url, error) => const Icon(Icons.image,size: 70,),
                  ),
                ),
          ),
        ),
        // message time
        Padding(
          padding: EdgeInsets.only(right: mq.width*.04,),
          child: Text(myDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),
      ],
    );
  }

  // our or user message
  Widget greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message time
        Row(
          children: [
            SizedBox(width: mq.width * .04),
            // double click blue icon for message read
            if(widget.message.read.isNotEmpty)
              Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),

            SizedBox(width: 2,),

            // sent time
            Text(
              myDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),

        // message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height* 0.01),
            decoration: BoxDecoration(color: Colors.green.shade300,border: Border.all(color: Colors.lightGreen),borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
            // show text
            Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87),
            )
                :
            // show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg,
                placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
                errorWidget: (context, url, error) => const Icon(Icons.image,size: 70,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
