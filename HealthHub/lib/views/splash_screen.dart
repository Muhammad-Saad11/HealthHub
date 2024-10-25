import 'package:bgmfitness/account_selection.dart';
import 'package:bgmfitness/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Selection()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color(0xFF1C1C1E),
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 116, width: 117, child: Image.asset('assets/logo.png')),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "FlexFit Hub",
            style: TextStyle(
                color: Colors.black, fontSize: 40, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ));
  }
}
