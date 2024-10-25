import 'package:bgmfitness/views/SellerPages/add_gym_page.dart';
import 'package:bgmfitness/views/SellerPages/seller_booking_history.dart';
import 'package:bgmfitness/views/SellerPages/seller_directory_page.dart';
import 'package:bgmfitness/views/SellerPages/seller_page_main.dart';
import 'package:bgmfitness/views/SellerPages/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providerclass.dart';
import '../Messenger Screens/home_screen.dart';
import 'add_nutritionist_page.dart';
import 'add_product .dart';
import 'private_mode_status.dart';

class SellerHomePage extends StatefulWidget {
  SellerHomePage({this.val = 0});
  final val;

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int currentIndex = 0;
  List screens = const [
    SellerMainPage(),
    MessengerScreen(),
    SellerDirectoryPage(),
    OrderTabs(),
  ];
  @override
  void initState() {
    pmode.getprivateMode();
    currentIndex = widget.val;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 50,
            top: 15,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(50.r)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: GNav(
                  duration: Duration(milliseconds: 100),
                  style: GnavStyle.google,
                  backgroundColor: Colors.black,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.white12,
                  padding: EdgeInsets.all(10),
                  selectedIndex: currentIndex,
                  gap: 8,
                  tabs: [
                    GButton(
                      icon: Icons.dashboard,
                      text: "Dashboard",
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.chat,
                      text: "Chat",
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.add_circle_outline,
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white.withOpacity(0),
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200.h,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.r),
                                      topRight: Radius.circular(20.r),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddGymPage()),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    size: 35.sp,
                                                    color: Colors.white,
                                                    Icons.fitness_center_sharp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text('Gym'),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddProductPage()),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    size: 35.sp,
                                                    color: Colors.white,
                                                    Icons.add_circle_outline,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text('Product'),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddNutritionistPage()),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    size: 35.sp,
                                                    color: Colors.white,
                                                    Icons.list_alt_rounded,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text('Nutritionist'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          },
                        );
                      },
                    ),
                    GButton(
                      icon: Icons.library_add,
                      text: "Directory",
                      onPressed: () {
                        setState(() {
                          currentIndex = 2;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.note_alt_outlined,
                      text: "bookings",
                      onPressed: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }
}
