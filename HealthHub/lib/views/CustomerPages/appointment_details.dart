import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../constants.dart';
import '../Messenger Screens/chat_screen.dart';

late ChatUser me;

class AppointmentDetailPage extends StatefulWidget {
  final bookingData;
  final vendorId;

  AppointmentDetailPage({this.bookingData, this.vendorId});

  @override
  State<AppointmentDetailPage> createState() =>
      _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
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
        title: const Text("Appointment Details"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.bookingData["orderStatus"]
                        ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kDarkBlue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Your Booking status has been updated to completed!",
                              style: TextStyle(color: Colors.white,fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                        : const SizedBox(),
                    const Text(
                      "Appointment Summary",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    Text(
                      "Appointment ticket:  ${widget.bookingData["orderId"]}",
                    ),
                    Text(
                        "Appointment Status:  ${widget.bookingData["orderStatus"] ? "Completed" : "In Process"}"),
                  ],
                ),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                const Text(
                  "Appointment Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Text(
                  "Appointment Booked On: ${widget.bookingData["bookingDate"]}",
                ),
                const Text("Selected Package:"),
                ExpandableText(
                  widget.bookingData["selectedPackage"].keys.first,
                  expandText: '\nShow More',
                  collapseText: '\nShow Less',
                  maxLines: 4,
                  linkColor: kPurple,
                  style: TextStyle(
                    color: black.withOpacity(0.4),
                    height: 1.5,
                  ),
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
                    Text("Package"),
                    Text(
                      "${widget.bookingData["selectedPackage"].keys.first}",
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
                      "${money.format(platformFee)} PKR",
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
                      "Contact the Vendor",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white
                        ),
                        onPressed: () async {
                          APIs.addChatUser("");
                          await FirebaseFirestore.instance
                              .collection('Accounts')
                              .doc(widget.vendorId)
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
