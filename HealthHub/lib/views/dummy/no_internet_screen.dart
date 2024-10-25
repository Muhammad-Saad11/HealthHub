import 'package:flutter/material.dart';
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/wifiOff.jpeg"),
            Text(
              "No Internet !",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Lora',
              ),
            )
          ],
        ),
      ),
    );
  }
}
