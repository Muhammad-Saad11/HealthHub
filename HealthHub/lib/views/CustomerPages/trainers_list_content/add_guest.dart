import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTrainersScreen extends StatelessWidget {
  final controller;
  VoidCallback onSave;

  AddTrainersScreen({
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add Trainer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                  fontFamily: 'SourceSansPro-SemiBold'
              ),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Add a new trainer",
              ),
            ),
            SizedBox(height: 20.h,),
            InkWell(
              onTap: onSave,
              child: Container(
                height: 48.sp,
                width: 220.w ,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Center(
                  child: Text("Add",style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
