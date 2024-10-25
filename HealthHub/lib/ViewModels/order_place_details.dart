import 'package:flutter/material.dart';
Widget orderplaceDetails({t1,t2,d1,d2}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$t1',style: TextStyle(fontWeight: FontWeight.w600),),
            Text('$d1',style: TextStyle(color: Colors.grey.shade700),)
          ],
        ),
        SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$t2',style: TextStyle(fontWeight: FontWeight.w600),),
              Text('$d2',style: TextStyle(color: Colors.grey.shade700),)
            ],
          ),
        )
      ],
    ),
  );
}