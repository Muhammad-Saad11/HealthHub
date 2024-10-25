import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ViewModels/customer_authentication.dart';

class Customer {
  String Name;
  String Email;
  String Password;
  String customerUID;

  Customer({
    this.Email = '',
    this.Name = '',
    this.Password = '',
    this.customerUID = '',
  });
  Future customer_signup(
      {String email = '', String password = '', String name = ''}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var customerid = FirebaseAuth.instance.currentUser!.uid;

    var record =
    FirebaseFirestore.instance.collection('Customers').doc(customerid);
    record.set({'Name': name, 'Email': email, 'Role': 'Customer'});

    var record1 =
    FirebaseFirestore.instance.collection('Accounts').doc(customerid);
    record1.set({'Name': name, 'Email': email, 'Role': 'Customer'});

    await createUser(name);

  }
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
