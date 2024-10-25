import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ViewModels/Vendor/genRandomString.dart';

updateVenueDate({
  required String venueId,
  required String bookingDate,
}) async {
  // Get a reference to the document you want to update
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Venues').doc(venueId);

  // Update the field
  await documentRef.update({
    'inActiveDates': FieldValue.arrayUnion([bookingDate])
  });

  debugPrint('Document updated successfully!');
}

String orderId = getRandomString();
String paymentStatus = 'onHold';
bool orderStatus = false;
bool bookingCompleted = false;
void bookVenue({
  required int payment,
  required String venueId,
  required String vendorUID,
  required String venueBookedOn,
  required String customerName,
  required String customerEmail,
  required Map<String, int> selectedMenu,
  required int expectedGuests,
  required String venueName,
  required String venueImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Vendor Orders")
      .doc(vendorUID)
      .collection("Venue Orders")
      .doc(orderId)
      .set({
    "orderId": orderId,
    "bookingDate": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    "venueBookedOn": venueBookedOn,
    "payment": payment,
    "venueId": venueId,
    "customerUID": customerUID,
    "paymentStatus": paymentStatus,
    "orderStatus": orderStatus,
    "customerName": customerName,
    "customerEmail": customerEmail,
    "selectedMenu": selectedMenu,
    "expectedGuests": expectedGuests,
    "venueName": venueName,
    "venueImg": venueImg,
    "bookingCompleted": bookingCompleted,
    "vendorUID": vendorUID
  });
}

//Adds payment to onHoldPayments in Vendor's Account
void updatePayments({
  required String nutritionistUID,
  required int payment,
}) {
  FirebaseFirestore.instance
      .collection('Vendors')
      .doc(nutritionistUID)
      .update({'onHoldPayments': FieldValue.increment(payment)}).then((_) {
    debugPrint('Value added successfully!');
  }).catchError((error) {
    debugPrint('Error adding value: $error');
  });
}

void bookingHistory({
  required int payment,
  required String venueId,
  required String vendorUID,
  required String venueBookedOn,
  required String vendorNumber,
  required String vendorEmail,
  required Map<String, int> selectedMenu,
  required int expectedGuests,
  required String venueName,
  required String venueImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("User Orders")
      .doc(customerUID)
      .collection("Venue Orders")
      .doc(orderId)
      .set({
    "orderId": orderId,
    "bookingDate": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    "venueBookedOn": venueBookedOn,
    "payment": payment,
    "venueId": venueId,
    "vendorUID": vendorUID,
    "orderStatus": orderStatus,
    "vendorNumber": vendorNumber,
    "vendorEmail": vendorEmail,
    "selectedMenu": selectedMenu,
    "expectedGuests": expectedGuests,
    "venueName": venueName,
    "venueImg": venueImg,
  });
}
