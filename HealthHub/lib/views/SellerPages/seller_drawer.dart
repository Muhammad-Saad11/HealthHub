import 'package:bgmfitness/views/SellerPages/private_mode_status.dart';
import 'package:bgmfitness/views/SellerPages/seller_completed_orders_screen.dart';
import 'package:bgmfitness/views/SellerPages/seller_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../constants.dart';
import '../../providerclass.dart';
import '../Messenger Screens/chat_screen.dart';

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

class SellerDrawer extends StatefulWidget {
  const SellerDrawer({Key? key}) : super(key: key);

  @override
  State<SellerDrawer> createState() => _SellerDrawerState();
}

class _SellerDrawerState extends State<SellerDrawer> {
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
                decoration:  BoxDecoration(color: Colors.black),
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
                      Text(auth.getUserEmail() ?? "Unknown",style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white
                      ),),
                    ],
                  ),
                )),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SwitchListTile(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.black,
                    value: pmode.private,
                    onChanged: (val) {
                      pmode.privateMode(val);
                      setState(() {});
                    },
                    title: const Text(
                      'Private Mode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return SellerHomePage(
                                val: 0,
                              );
                            }));
                      },
                      child: listTile(icon: Icons.dashboard, title: "Dashboard")),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return SellerHomePage(
                                val: 1,
                              );
                            }));
                      },
                      child: listTile(icon: Icons.chat, title: "Chats")),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return SellerHomePage(
                                val: 2,
                              );
                            }));
                      },
                      child: listTile(
                          icon: Icons.store_mall_directory,
                          title: "Booking History")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>CompletedSellerOrders()
                          ),
                        );
                      },
                      child: listTile(icon: Icons.history, title: "Orders History")),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return SellerHomePage(
                                val: 3,
                              );
                            }));
                      },
                      child: listTile(icon: Icons.library_add, title: "Directory")),

                  InkWell(
                      onTap: () async {
                        APIs.addChatUser("admin@gmail.com");
                        await FirebaseFirestore.instance
                            .collection('Accounts')
                            .doc('xZj76WU5vkT9JtYrhneQITvlC7y2')
                            .get()
                            .then((user) async {
                          if (user.exists) {
                            me = ChatUser.fromJson(user.data()!);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ChatScreen(user: me)));
                          }
                        });
                      },
                      child: listTile(icon: Icons.person, title: "Contact Admin")),

                  InkWell(
                      onTap: () {
                        auth.signOut().whenComplete(() =>
                        Navigator.pushReplacementNamed(context, 'mainScreen'));

                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => route.isFirst);
                      },
                      child:
                      listTile(icon: Icons.logout_outlined, title: "Sign out")),
                   SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(height: 15,),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                            "Support",
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                          )),
                      Center(child: Text("Contact: 042 111 111 111")),
                      Center(child: Text("Email: BGUFitness@gmail.com")),
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