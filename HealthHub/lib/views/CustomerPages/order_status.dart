import 'package:flutter/material.dart';
Widget orderStatus({icon,color,title,showDone}){
  return ListTile(
    leading: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: color),
            borderRadius: BorderRadius.circular(7)
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon,
        color: color,
        ),
      ),
    ),
    title: Text('$title',style: TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    ),),
    trailing: showDone ? Icon(Icons.done,color: Colors.red,) : SizedBox(width: 10,),
  );
}