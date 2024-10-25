import 'package:bgmfitness/views/CustomerPages/appointment_history.dart';
import 'package:bgmfitness/views/CustomerPages/bmi_cal/bmi_cal.dart';
import 'package:bgmfitness/views/CustomerPages/customer_bottom_nav_bar.dart';
import 'package:bgmfitness/views/CustomerPages/map/mapscreen.dart';
import 'package:bgmfitness/views/CustomerPages/steps_calculator/step_cal.dart';
import 'package:bgmfitness/views/CustomerPages/trainers_list_content/guest_list_main.dart';
import 'package:bgmfitness/views/SellerPages/private_mode_status.dart';
import 'package:bgmfitness/views/SellerPages/seller_completed_orders_screen.dart';
import 'package:bgmfitness/views/SellerPages/seller_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../providerclass.dart';
import '../Messenger Screens/chat_screen.dart';
import 'booking_history.dart';

Widget listTile({IconData? icon, String title = ""}) {
  return ListTile(
    leading: Icon(
      icon,
      size: 32.sp,
      color: Colors.black,
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
  );
}

late ChatUser me;

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({Key? key}) : super(key: key);

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);
    var mq = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/prof.jpeg'),
                        backgroundColor: Colors.black45,
                        radius: 50.r,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        auth.getUserEmail() ?? "Unknown",
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerHomePage(val: 0);
                        }));
                      },
                      child:
                          listTile(icon: Icons.home_outlined, title: "Home")),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerHomePage(val: 1);
                        }));
                      },
                      child: listTile(
                          icon: Icons.mail_outlined, title: "Messages")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookingHistory()),
                        );
                      },
                      child: listTile(
                          icon: Icons.history, title: "Booking History")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppointmentHistory()),
                        );
                      },
                      child: listTile(
                          icon: Icons.note_alt_outlined,
                          title: "Appointment History")),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerHomePage(val: 4);
                        }));
                      },
                      child: listTile(
                          icon: Icons.inventory_outlined, title: "Check List")),
                  // InkWell(
                  //     onTap: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) {
                  //         return TrainersList();
                  //       }));
                  //     },
                  //     child: listTile(
                  //         icon: Icons.person_add_alt, title: "Trainers List")),
                  InkWell(
                      onTap: () async {
                        APIs.addChatUser("admin@gmail.com");
                        await FirebaseFirestore.instance
                            .collection('Accounts')
                            .doc('rmnp4y25kfYSLPQ3pi9LS19RPgh2')
                            .get()
                            .then((user) async {
                          if (user.exists) {
                            me = ChatUser.fromJson(user.data()!);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatScreen(user: me)));
                          }
                        });
                      },
                      child:
                          listTile(icon: Icons.person, title: "Contact Admin")),

                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => WorkoutMapScreen()));
                      },
                      child: listTile(icon: Icons.map, title: "Map")),

                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StepCalculatorScreeen()));
                      },
                      child: listTile(
                          icon: Icons.baby_changing_station,
                          title: "Step Calculator")),

                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BMICalculatorScreen()));
                      },
                      child: listTile(
                          icon: Icons.calculate, title: "BMI Calculator")),
                  InkWell(
                      onTap: () {
                        auth.signOut().whenComplete(() =>
                            Navigator.pushReplacementNamed(
                                context, 'mainScreen'));

                        // Navigator.pushAndRemoveUntil(context, Selection(), (route) => route.isFirst);
                      },
                      child: listTile(
                          icon: Icons.logout_outlined, title: "Sign out")),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Support",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      )),
                      Center(child: Text("Contact: 042 111 111 111")),
                      Center(child: Text("Email: FlexFitFitness@gmail.com")),
                      SizedBox(height: 20.h)
                    ],
                  ),
                  // SizedBox(
                  //   height: 220.h,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.sp),
                  //     child:
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
