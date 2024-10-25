import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/Messenger Models/chat_user.dart';

int readyPayments = 0;
int onHoldPayments = 0;
var user = FirebaseAuth.instance.currentUser!;

Future vendorSignup({
  required String email,
  required String businessName,
  required String password,
  required String name,
  required String cnic,
  required String number,
  required String address,
}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);

  var vendorUID = FirebaseAuth.instance.currentUser!.uid;
  var record = FirebaseFirestore.instance.collection('Vendors').doc(vendorUID);
  await record.set({
    'Name': name,
    'Email': email,
    'BusinessName': businessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor',
    'readyPayments': readyPayments,
    'onHoldPayments': onHoldPayments,
    'vendorUID': vendorUID
  });
  record = FirebaseFirestore.instance.collection('Accounts').doc(vendorUID);
  await record.set({
    'Name': name,
    'Email': email,
    'BusinessName': businessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor'
  });

  record =
      FirebaseFirestore.instance.collection('Vendor Requests').doc(vendorUID);
  await record.set({
    'Id': vendorUID,
    'Name': name,
    'Email': email,
    'BusinessName': businessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor',
    'RequestStatus': 'waiting'
  });
  await createUser(name);
}

Future<void> createUser(String username) async {
  final time = DateTime.now().millisecondsSinceEpoch.toString();

  final chatUser = ChatUser(
    id: user.uid,
    name: username,
    email: user.email.toString(),
    about: "Hey, I'm using FlexFit Hub!",
    image: user.photoURL.toString(),
    createdAt: time,
    isOnline: false,
    lastActive: time,
  );

  return await FirebaseFirestore.instance
      .collection('Accounts')
      .doc(user.uid)
      .update(chatUser.toJson());
}
