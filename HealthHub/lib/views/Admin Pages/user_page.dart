import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:bgmfitness/views/Admin%20Pages/user_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'admin_drawer.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final Stream<QuerySnapshot> customerStream =
      FirebaseFirestore.instance.collection('Customers').snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Customers")),
        drawer: AdminDrawer(),
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding / 2,
                  right: kDefaultPadding / 2,
                  bottom: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: kDarkBlue,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.20,
                        child: Row(
                          children: [
                            buildRequestTab(
                              title: "Total Active Users",
                              usersStream: FirebaseFirestore.instance
                                  .collection('Customers')
                                  .snapshots(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(
                top: kDefaultPadding,
                left: kDefaultPadding / 2,
                right: kDefaultPadding / 2,
              ),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 1.0,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Active Users",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, //New
                      blurRadius: 1.0,
                    )
                  ],
                  color: Colors.white,
                ),
                child: TabBarView(
                  children: [
                    buildRequestStatus(usersStream: customerStream),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildRequestTab({
    required title,
    required Stream<QuerySnapshot<Object?>> usersStream,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
          top: kDefaultPadding,
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2,
        ),
        height: double.infinity,
        decoration: BoxDecoration(
          color: kPurple.withAlpha(90),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  int documentCount = snapshot.data!.docs.length;
                  return Center(
                    child: Text(
                      documentCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return const CircularProgressIndicator(); // Placeholder while loading
              },
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildRequestStatus({
    required Stream<QuerySnapshot<Object?>> usersStream,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data?.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      data!['Name'].toString().toTitleCase()[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    data['Name'].toString().toTitleCase(),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    data['Email'].toString().toTitleCase(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerDetailsPage(userData: data)),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
