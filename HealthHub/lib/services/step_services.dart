import 'package:bgmfitness/Models/step_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Stream<StepsModel> getSteps() {
    User? user = _auth.currentUser;
    var details = firebaseFirestore
        .collection("steps")
        .doc(user!.uid)
        .snapshots()
        .map((snapshots) => StepsModel.fromMap(snapshots.data()));

    return details;
  }

  void updateSteps(StepsModel data) {
    User? user = _auth.currentUser;
    // firebaseFirestore
    //     .collection("steps")
    //     .doc(user!.uid)
    //     .update({"stepsData":FieldValue.delete()}).
    // whenComplete(() =>
    // print('field Deleted')
    // );

    print("Helllloo");

    var details = firebaseFirestore.collection("steps").doc(user!.uid).update({
      'calorie': data.calorie,
      'date': data.date,
      'steps': data.steps,
      'uid': user.uid.toString(),
      'stepsData': FieldValue.arrayUnion([
        {'steps': data.steps, 'date': data.date}
      ])
    });
  }

  postSteps(
    BuildContext context,
    String calories,
    String steps,
    String date,

    // String key,
    // String stepCache,
    // List<Map<String,dynamic>> stepsData,
  ) async {
    print("Postt");
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = await _auth.currentUser;
    firebaseFirestore.collection("steps").doc(user!.uid).update({
      'calorie': calories,
      'date': date,
      'steps': steps,
      'uid': user.uid.toString(),
      'stepsData': FieldValue.arrayUnion([
        {'steps': steps, 'date': date}
      ])
    });
  }
}
