import 'package:bgmfitness/views/CustomerPages/appointment_details.dart';
import 'package:bgmfitness/views/CustomerPages/booking_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({Key? key}) : super(key: key);

  @override
  State<AppointmentHistory> createState() =>
      _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  final Stream<QuerySnapshot> pendingBookings = FirebaseFirestore.instance
      .collection('Appointments').where('customerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('orderStatus',isEqualTo: false)
      .snapshots();

  final Stream<QuerySnapshot> completedBookings = FirebaseFirestore.instance
      .collection('Appointments').where('customerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('orderStatus',isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointment History'),
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Completed",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildBookingHistory(streams: pendingBookings),
                  buildBookingHistory(streams: completedBookings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildBookingHistory(
      {required streams}) {
    return StreamBuilder<QuerySnapshot>(
      stream: streams,
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

        return snapshot.data!.docs.isEmpty
            ? const Center(
          child: Text(
            "No Appointment History",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        )
            : ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var bookingData = snapshot.data?.docs[index];
            // DateTime dt = (bookingData!['bookingDate'] as Timestamp).toDate();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AppointmentDetailPage(
                                  bookingData: bookingData,
                                  vendorId: bookingData['nutritionistsUID'],
                                )));
                  },
                  leading: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Image.network(
                        bookingData!['nutritionistsImg'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text("Gym: ${bookingData['nutritionistsName']}"),
                  subtitle: Text('Appointment is made on ${bookingData!['bookingDate']}'),
                  trailing: const Icon(Icons.touch_app),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
