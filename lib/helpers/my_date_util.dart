import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myDateUtil{
  // for getting formatted time from milliSecondsSinceEpoch String
  static String getFormattedTime(
      {required BuildContext context, required String time}){
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
  // get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,required String time}){
    final DateTime sent = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${getMonth(sent)}';
  }

  // get month name from month no. or index
  static String getMonth(DateTime date){
      switch(date.month){
        case 1:
          return 'jan';
        case 2:
          return 'feb';
        case 3:
          return 'mar';
        case 4:
          return 'apr';
        case 5:
          return 'may';
        case 6:
          return 'jun';
        case 7:
          return 'jul';
        case 8:
          return 'aug';
        case 9:
          return 'sep';
        case 10:
          return 'oct';
        case 11:
          return 'nov';
        case 12:
          return 'dec';
      }
      return 'NA';
  }
}