import 'package:bgmfitness/views/SellerPages/seller_appointment_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SellerAppointmentPage extends StatefulWidget {
  const SellerAppointmentPage({Key? key}) : super(key: key);

  @override
  State<SellerAppointmentPage> createState() =>
      _SellerAppointmentPageState();
}

class _SellerAppointmentPageState
    extends State<SellerAppointmentPage> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('Appointments')
      .where('nutritionistsUID')
      .where('appointmentCompleted', isEqualTo: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Appointments"),
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
                    "No Appointments",
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
                    String bookingDate = venueOrderData['bookingDate'];

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
                                        SellerAppointmentDetailPage(
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
                                venueOrderData['nutritionistsImg'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text("Doctor: ${venueOrderData['nutritionistsName']}"),
                          subtitle: Text(
                              '$customerName has booked an appointment on $bookingDate'),
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
