import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'genRandomString.dart';

class AddProductProvider {

  void addProductData({
    required List productImages,
    required String productLocation,
    required String productName,
    required int productPrice,
    required String productDescription,
    required int productRating,
    required int productFeedback,
    required String productNumber,
    required int productQuantity,
    required String productSize,
    required String productCategory,
    required int productDelivery,
  }) async {
    await FirebaseFirestore.instance.collection("Products").doc().set({
      "productId": Random().nextInt(100000).toString(),
      "productImages": productImages,
      "productAddress": productLocation,
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "sellerUID": FirebaseAuth.instance.currentUser!.uid,
      "productRating": productRating,
      "productFeedback": productFeedback,
      "sellerNumber": productNumber,
      "isPrivate": false,
      "sellerEmail": FirebaseAuth.instance.currentUser!.email,
      "availableQuantity": productQuantity,
      "productSize": productSize,
      "productCategory": productCategory,
      "productDelivery": productDelivery
    });
  }

}

String? vendorName;
getVendorName() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      vendorName = snapshot.get('Name').toString();
    }
  } catch (e) {
    print('Error: $e');
  }
}

updateBookingStatus({
  required String orderId,
  required String customerUId,
}) async {
  // Get a reference to the document you want to update
  FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'orderStatus': true,
  });
  FirebaseFirestore.instance
      .collection('User Orders')
      .doc(customerUId)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'orderStatus': true,
  });
}

updateAppointmentStatus({
  required String orderId,
  required String customerUId,
}) async {
  // Get a reference to the document you want to update
  var collection = await FirebaseFirestore.instance
      .collection('Appointments')
      .where('orderId',isEqualTo: orderId).get();
  var docId = collection.docs[0].id;
  FirebaseFirestore.instance
      .collection('Appointments')
      .doc(docId)
      .update({
    'orderStatus': true,
  });
}

isBookingCompleted({
  required String orderId,
}) async {
  // Get a reference to the document you want to update

  await FirebaseFirestore.instance
      .collection('Gym Bookings')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'bookingCompleted': true,
  });
}

isAppointmentCompleted({
  required String orderId,
}) async {
  // Get a reference to the document you want to update

  var collection = await FirebaseFirestore.instance
      .collection('Appointments')
      .where('orderId',isEqualTo: orderId).get();
  var docId = collection.docs[0].id;
  await FirebaseFirestore.instance
      .collection('Appointments')
      .doc(docId)
      .update({
    'appointmentCompleted': true,
  });
}

void payVendor({required int payment, required final vendorUID}) {
  FirebaseFirestore.instance.collection('Vendors').doc(vendorUID).update({
    'readyPayments': FieldValue.increment(payment),
  }).then((_) {
    debugPrint('Value added successfully!');
  }).catchError((error) {
    debugPrint('Error adding value: $error');
  });
}

const updatedStatus = "approved";
void releaseVendorPayments({
  required int payment,
  required String orderId,
}) {
  FirebaseFirestore.instance
      .collection('Vendors')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'readyPayments': FieldValue.increment(payment),
    'onHoldPayments': FieldValue.increment(-payment),
  }).then((_) {
    debugPrint('Value added successfully!');
  }).catchError((error) {
    debugPrint('Error adding value: $error');
  });

  FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'paymentStatus': updatedStatus,
  }).then((value) {
    print('Order status updated successfully');
  }).catchError((error) {
    print('Failed to update order status: $error');
  });
}

deleteGym(String gymId) async {
  var docRef = await FirebaseFirestore.instance.collection("Gyms").where('gymId',isEqualTo: gymId).get();
  var docId = docRef.docs[0].id;
  var document = await FirebaseFirestore.instance;
  document.collection("Gyms").doc(docId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}
deleteProduct(String productId) async {
  var docRef = await FirebaseFirestore.instance.collection("Products").where('productId',isEqualTo: productId).get();
  var docId = docRef.docs[0].id;
  var document = await FirebaseFirestore.instance;
  document.collection("Products").doc(docId).delete().then(
        (doc) => print("Document deleted"),
    onError: (e) => print("Error updating document $e"),
  );
}
deleteNutritionist(String nutritionistId) async {
  var docRef = await FirebaseFirestore.instance.collection("Nutritionists").where('nutritionistsId',isEqualTo: nutritionistId).get();
  var docId = docRef.docs[0].id;
  var document = await FirebaseFirestore.instance;
  document.collection("Nutritionists").doc(docId).delete().then(
        (doc) => print("Document deleted"),
    onError: (e) => print("Error updating document $e"),
  );
}
void updateProductData({
  required String productId,
  required String productLocation,
  required String productName,
  required int productPrice,
  required String productDescription,
  required String productNumber,
  required int productQuantity,
  required String productSize,
  required String productCategory,
  required int productDelivery,
  required bool isPrivate,
}) async {
  await FirebaseFirestore.instance
      .collection("Products")
      .where("productId", isEqualTo: productId)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "productAddress": productLocation,
        "productName": productName,
        "productPrice": productPrice,
        "productDescription": productDescription,
        "sellerNumber": productNumber,
        "isPrivate": isPrivate,
        "availableQuantity": productQuantity,
        "productSize": productSize,
        "productCategory": productCategory,
        "productDelivery": productDelivery,
      });
    });
  });
}

