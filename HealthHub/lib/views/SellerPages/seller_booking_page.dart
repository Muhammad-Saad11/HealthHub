import 'package:bgmfitness/views/SellerPages/seller_booking_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SellerBookingPage extends StatefulWidget {
  const SellerBookingPage({Key? key}) : super(key: key);

  @override
  State<SellerBookingPage> createState() => _SellerBookingPageState();
}

class _SellerBookingPageState extends State<SellerBookingPage> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('Gym Bookings')
      .where('bookingEnds', isGreaterThan: DateTime.now())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Booking Orders"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text(
                    "No Bookings",
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
                    var venueOrderData = snapshot.data?.docs[index];

                    String customerName = venueOrderData!['customerName'];
                    var bookingDate = (venueOrderData['gymBookedOn'] as Timestamp).toDate();

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
                                        SellerBookingDetailPage(
                                          bookingData: venueOrderData,
                                          email:
                                              venueOrderData['customerEmail'],
                                          customerId:
                                              venueOrderData['customerUID'],
                                        )));
                          },
                          leading: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Image.network(
                                venueOrderData['gymImg'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Venue: ${venueOrderData['gymName']}"),
                          subtitle: Text(
                              '$customerName has booked this Venue on date: $bookingDate'),
                          trailing: const Icon(Icons.touch_app),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
