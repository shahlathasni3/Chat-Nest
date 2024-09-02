import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Cat_user_card extends StatefulWidget {
  const Cat_user_card({super.key});

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
          // user profile
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          // user name
          title: Text('Demo User'),
          // user last message
          subtitle: Text('Last User Message',maxLines: 1,),
          // user last message time
          trailing: Text("12:00 PM",style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}
