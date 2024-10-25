import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'genRandomString.dart';

String orderId = getRandomString();
String paymentStatus = 'onHold';
bool orderStatus = false;
var bookingDate = DateTime.now();

void bookGym({
  required int payment,
  required String gymId,
  required String gymUID,
  required int days,
  required String customerName,
  required String customerEmail,
  required Map<String, int> selectedPackage,
  required String gymName,
  required String gymImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Gym Bookings").doc().set({
    "orderId": orderId,
    "gymBookedOn": bookingDate,
    "payment": payment,
    "gymId": gymId,
    "customerUID": customerUID,
    "paymentStatus": paymentStatus,
    "orderStatus": orderStatus,
    "customerName": customerName,
    "customerEmail": customerEmail,
    "selectedPackage": selectedPackage,
    "gymName": gymName,
    "gymImg": gymImg,
    "bookingEnds": bookingDate.add( Duration(days: days)),
    "gymUID": gymUID
  });
}
