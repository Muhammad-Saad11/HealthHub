import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providerclass.dart';
import 'admin_page.dart';

Widget listTile({IconData? icon, String title = ""}) {
  return ListTile(
    leading: Icon(
      icon,
      size: 32,
      color: Colors.black,
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
  );
}


class AdminDrawer extends StatelessWidget {
  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black54),
                child: Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/prof.jpeg'),
                        backgroundColor: Colors.black45,
                        radius: 50,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(auth.getUserEmail() ?? "Unknown",style: TextStyle(
                        color: Colors.white
                      ),),
                    ],
                  ),
                )),


            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return  AdminPage(val: 0,);

                      }));
                },
                child: listTile(icon: Icons.store, title: "Vendors")),

            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return  AdminPage(val: 1,);
                      }));
                },
                child: listTile(icon: Icons.person, title: "Customers")),

            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return  AdminPage(val: 2,);

                      }));
                },
                child: listTile(icon: Icons.history, title: "Payments")),


            InkWell(
                onTap: () {
                  auth.signOut().whenComplete(() =>
                      Navigator.pushReplacementNamed(context, 'mainScreen')
                  );

                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => route.isFirst);
                },
                child:
                listTile(icon: Icons.logout_outlined, title: "Sign out")),

          ],
        ),
      ),
    );
  }
}
