import 'package:bgmfitness/loading_screen.dart';
import 'package:bgmfitness/views/SellerPages/seller_status_check.dart';
import 'package:bgmfitness/views/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Selection extends StatefulWidget {
  const Selection({super.key});

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return UserManage(context);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something Went Wrong'),
              );
            } else {
              return WelcomePage();
            }
          }
        });
  }
}

Widget UserManage(BuildContext context) {
  var info = FirebaseFirestore.instance
      .collection('Accounts')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  info.then((value) {
    if (value.get('Role') == 'Admin') {
      Navigator.pushNamedAndRemoveUntil(context, 'admin', (route) => false);
    } else if ((value.get('Role') == 'Customer')) {
      Navigator.pushNamedAndRemoveUntil(context, 'customer', (route) => false);
    } else {
      VendorDecidor(context);
    }
  });
  return LoadingScreen();
}
