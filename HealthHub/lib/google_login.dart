import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Models/Messenger Models/chat_user.dart';


final googleSignin=GoogleSignIn();

Future googleLogin()async{
  final googleUser=await googleSignin.signIn();
  if(googleUser==null) return;

  final googleAuth= await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
  );
  await FirebaseAuth.instance.signInWithCredential(credential);
  final user =  FirebaseAuth.instance.currentUser!;
  var customerid = FirebaseAuth.instance.currentUser!.uid;
  var record =
  FirebaseFirestore.instance.collection('Customers').doc(customerid);
  record.set({'Name': user.displayName, 'Email': user.email, 'Role': 'Customer'});

  var record1 =
  FirebaseFirestore.instance.collection('Accounts').doc(customerid);
  record1.set({'Name': user.displayName, 'Email': user.email, 'Role': 'Customer'});
  await createUser();
}

Future<void> createUser() async {
  final user = await FirebaseAuth.instance.currentUser!;

  final time = DateTime
      .now()
      .millisecondsSinceEpoch
      .toString();

  final chatUser = ChatUser(
    id: user.uid,
    name: user.displayName.toString(),
    email: user.email.toString(),
    about: "Hey, I'm using BGU Fitness",
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