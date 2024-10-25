import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:bgmfitness/views/Admin%20Pages/gym_payment_detail_page.dart';
import 'package:bgmfitness/views/Admin%20Pages/nutritionist_payment_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';
import '../../constants.dart';
import 'admin_drawer.dart';

class ManagePaymentsPage extends StatefulWidget {
  const ManagePaymentsPage({Key? key}) : super(key: key);

  @override
  State<ManagePaymentsPage> createState() => _ManagePaymentsPageState();
}

class _ManagePaymentsPageState extends State<ManagePaymentsPage> {
  final Stream<QuerySnapshot> appointments = FirebaseFirestore.instance
      .collection('Appointments')
      .where('paymentStatus', whereIn: ['onHold','onHoldByAdmin']).snapshots();

  final Stream<QuerySnapshot> bookings = FirebaseFirestore.instance
      .collection('Gym Bookings')
      .where('paymentStatus', whereIn: ['onHold','onHoldByAdmin']).snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Payments"),
        ),
        drawer: AdminDrawer(),
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
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
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Appointments",
                  ),
                  Tab(
                    text: "Gym Bookings",
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
                    StreamBuilder<QuerySnapshot>(
                      stream: appointments,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).indicatorColor,
                              ),
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
                                      data!['nutritionistsName']
                                          .toString()
                                          .toTitleCase()[0],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    data['orderId'].toString().toTitleCase(),
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    data['paymentStatus']
                                        .toString()
                                        .toTitleCase(),
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
                                              NutritionistPayment(userData: data)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: bookings,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).indicatorColor,
                              ),
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
                                      data!['gymName']
                                          .toString()
                                          .toTitleCase()[0],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    data['orderId'].toString().toTitleCase(),
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    data['paymentStatus']
                                        .toString()
                                        .toTitleCase(),
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
                                              GymPayment(userData: data)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
