import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SellerRequestPage extends StatelessWidget {
  const SellerRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Request Sent for seller account registeration",),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'mainScreen');
                },
                child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
