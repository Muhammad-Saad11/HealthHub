import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../ViewModels/Vendor/product_provider.dart';
import '../../constants.dart';
import '../Messenger Screens/chat_screen.dart';

late ChatUser me;

class SellerAppointmentDetailPage extends StatefulWidget {
  final bookingData;
  final email;
  final customerId;

  SellerAppointmentDetailPage({this.bookingData, this.email, this.customerId});

  @override
  State<SellerAppointmentDetailPage> createState() => _SellerAppointmentDetailPageState();
}

formatDate(String date) {
  return date.substring(0, date.indexOf(' '));
}

class _SellerAppointmentDetailPageState extends State<SellerAppointmentDetailPage> {
  final money = NumberFormat("#,##0", "en_US");
  late bool status = widget.bookingData["orderStatus"];
  late bool appointmentStatus = widget.bookingData["appointmentCompleted"];
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
            SwitchListTile(
                title: const Text(
                  'Appointment Confirmed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                value: status,
                onChanged: (value) {
                  status
                      ? " "
                      : showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Update Appointment Status'),
                      content: const Text(
                          'This will notify the user about their appointment status!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              status = true;
                            });
                            updateAppointmentStatus(
                                orderId: widget.bookingData["orderId"],
                                customerUId:
                                widget.bookingData["customerUID"]);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }),
            SwitchListTile(
                title: const Text(
                  'Appointment Completed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                value: appointmentStatus,
                onChanged: (value) {
                  appointmentStatus
                      ? " "
                      : showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Update Appointment Status'),
                      content: const Text(
                          'Are you sure you want to update Appointment status as completed'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              appointmentStatus = true;
                            });
                            isAppointmentCompleted(
                                orderId: widget.bookingData["orderId"]);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }),
            buildDivider(),
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
                            "Appointment Summary",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            "Appointment number: ${widget.bookingData["orderId"]}",
                          ),
                          Text("Date:  ${widget.bookingData["bookingDate"]}"),
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
                    "Appointment Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Appointment made On: ${widget.bookingData["bookingDate"]}",
                  ),
                  const SizedBox(height: 10),
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
                      Text(
                        "${widget.bookingData["selectedPackage"].values.first} PKR",
                      ),
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
                        "-5,000 PKR",
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
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black
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
