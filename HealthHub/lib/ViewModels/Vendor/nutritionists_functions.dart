import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'genRandomString.dart';

String orderId = getRandomString();
String paymentStatus = 'onHold';
bool orderStatus = false;
bool appointmentCompleted = false;
void bookNutritionist({
  required int payment,
  required String nutritionistId,
  required String nutritionistUID,
  required String nutrionistsBookedOn,
  required String customerName,
  required String customerEmail,
  required Map<String, int> selectedPackage,
  required String nutritionistsName,
  required String nutritionistsImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Appointments")
      .doc()
      .set({
    "orderId": orderId,
    "bookingDate": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    "nutritionistsBookedOn": nutrionistsBookedOn,
    "payment": payment,
    "nutritionistsId": nutritionistId,
    "customerUID": customerUID,
    "paymentStatus": paymentStatus,
    "orderStatus": orderStatus,
    "customerName": customerName,
    "customerEmail": customerEmail,
    "selectedPackage": selectedPackage,
    "nutritionistsName": nutritionistsName,
    "nutritionistsImg": nutritionistsImg,
    "appointmentCompleted": appointmentCompleted,
    "nutritionistsUID": nutritionistUID
  });
}

updateDate({
  required String NutritionistsId,
  required String bookingDate,
}) async {
  // Get a reference to the document you want to update
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Nutritionists').doc(NutritionistsId);

  // Update the field
  await documentRef.update({
    'inActiveDates': FieldValue.arrayUnion([bookingDate])
  });

  debugPrint('Document updated successfully!');
}

