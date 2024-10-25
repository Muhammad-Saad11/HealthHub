import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SellerBlockedPage extends StatelessWidget {
  const SellerBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your account has been blocked by admin",),
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
