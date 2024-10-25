import 'package:bgmfitness/views/CustomerPages/TodoList/pages/home_page.dart';
import 'package:bgmfitness/views/CustomerPages/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../Messenger Screens/home_screen.dart';
import 'package:bgmfitness/views/SellerPages/private_mode_status.dart';
import 'customer_main_Page.dart';
import 'orders_tab_bar.dart';

class CustomerHomePage extends StatefulWidget {
  CustomerHomePage({this.val = 0});
  final val;

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int currentIndex = 0;
  List screens = const [
    CustomerMainPage(),
    MessengerScreen(),
    ReviewCart(),
    CustomerOrderTabs(),
    CheckList()
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
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 50),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(50.r)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      icon: Icons.home_outlined,
                      text: "Home",
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.mail_outlined,
                      text: "Messages",
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.shopping_cart_outlined,
                      text: "Cart",
                      onPressed: () {
                        setState(() {
                          currentIndex = 2;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.history,
                      text: "Orders",
                      onPressed: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.inventory_outlined,
                      text: "Check List",
                      onPressed: () {
                        setState(() {
                          currentIndex = 4;
                        });
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }
}
