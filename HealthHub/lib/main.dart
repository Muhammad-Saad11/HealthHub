import 'package:bgmfitness/providerclass.dart';
import 'package:bgmfitness/views/Admin%20Pages/admin_page.dart';
import 'package:bgmfitness/views/SellerPages/seller_block_page.dart';
import 'package:bgmfitness/views/SellerPages/seller_home_page.dart';
import 'package:bgmfitness/views/dummy/no_internet.dart';
import 'package:bgmfitness/views/dummy/seller_request_page.dart';
import 'package:bgmfitness/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'account_selection.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
      child: ScreenUtilInit(
        designSize: Size(411.428, 866.285),
        builder: (BuildContext context,child)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
            routes: {
              'StreamPage': (context) => MyApp(),
              'admin': (context) => AdminPage(),
              'customer': (context) => NoInternet(),
              'vendorWait': (context) => SellerRequestPage(),
              'vendorBlocked': (context) => SellerBlockedPage(),
              'vendorMain': (context) => SellerHomePage(),
              'mainScreen': (context) => Selection()
            },
          home: SplashScreen()
        ),
      ),
    );
  }
}
