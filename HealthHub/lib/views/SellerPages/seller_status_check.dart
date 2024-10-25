import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget VendorDecidor(BuildContext context){
  var info = FirebaseFirestore.instance.collection('Vendor Requests').doc(FirebaseAuth.instance.currentUser!.uid).get();
  info.then((value) {
    if(value.get('RequestStatus')=='approved'){
      Navigator.pushNamedAndRemoveUntil(context, 'vendorMain', (route) => false);
    }
    else if(value.get('RequestStatus')=='rejected'){
      Navigator.pushNamedAndRemoveUntil(context, 'vendorBlocked', (route) => false);
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, 'vendorWait', (route) => false);
    }
  });
  return Center(child: CircularProgressIndicator());
}