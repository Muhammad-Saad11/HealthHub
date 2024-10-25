import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../constants.dart';
import '../Messenger Screens/chat_screen.dart';

late ChatUser me;

class SellerBookingDetailPage extends StatefulWidget {
  final bookingData;
  final email;
  final customerId;

  SellerBookingDetailPage({this.bookingData, this.email, this.customerId});

  @override
  State<SellerBookingDetailPage> createState() =>
      _SellerBookingDetailPageState();
}

formatDate(String date) {
  return date.substring(0, date.indexOf(' '));
}

class _SellerBookingDetailPageState extends State<SellerBookingDetailPage> {
  final money = NumberFormat("#,##0", "en_US");
  final int platformFee = 300;
  @override
  Widget build(BuildContext context) {
    Divider buildDivider() {
      return Divider(
        thickness: 1,
        color: kPurple.withOpacity(0.2),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Booking Details"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Booking Summary",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            "Booking number: ${widget.bookingData["orderId"]}",
                          ),
                          Text("Date:  ${(widget.bookingData["gymBookedOn"] as Timestamp).toDate()}"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDivider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Customer Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Text("Name: ${widget.bookingData["customerName"]}"),
                  Text("Email: ${widget.bookingData["customerEmail"]}"),
                  const SizedBox(height: 10),
                  buildDivider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Booking Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Gym Booked On: ${(widget.bookingData["gymBookedOn"] as Timestamp).toDate()}",
                  ),
                  Text(
                    "Booking End Date: ${(widget.bookingData["bookingEnds"] as Timestamp).toDate()}",
                  ),

                  const SizedBox(height: 10),
                  buildDivider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "${money.format(widget.bookingData["payment"] + platformFee)} PKR", // "${money.format(widget.perPerson * guests)} PKR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Platform Fee",
                      ),
                      Text(
                        "-300 PKR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                      ),
                      Text(
                        "${money.format(widget.bookingData["payment"])} PKR", // "${money.format(widget.perPerson * guests)} PKR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Contact the User",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white
                           ),
                          onPressed: () async {
                            APIs.addChatUser(widget.email);
                            await FirebaseFirestore.instance
                                .collection('Accounts')
                                .doc(widget.customerId)
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
                          child: const Text("Message")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDivider(),
                ],
              ),
            ),
          ],
        ));
  }
}
