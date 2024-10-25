import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'genRandomString.dart';

class GymProvider {
  String gymId = getRandomString();

  void addGymData({
    required List gymImages,
    required String gymLocation,
    required String gymName,
    required String gymDescription,
    required String gymAddress,
    required int gymRating,
    required int gymFeedback,
    required String gymNumber,
    required int startingPrice,
    required Map<String, int> packages,
  }) async {
    await FirebaseFirestore.instance
        .collection("Gyms")
        .doc(gymId)
        .set({
      "gymId": gymId,
      "gymImages": gymImages,
      "gymLocation": gymLocation,
      "gymName": gymName,
      "gymDescription": gymDescription,
      "gymAddress": gymAddress,
      "gymUID": FirebaseAuth.instance.currentUser!.uid,
      "gymRating": gymRating,
      "gymFeedback": gymFeedback,
      "gymNumber": gymNumber,
      "startingPrice": startingPrice,
      "gymPackages": packages,
      "isPrivate": false,
      "gymEmail": FirebaseAuth.instance.currentUser!.email,
    });
  }
  void updateGymData({
    required String gymId,
    required String gymLocation,
    required String gymName,
    required String gymDescription,
    required String gymAddress,
    required String gymNumber,
    required int startingPrice,
    required Map<String, int> packages,
  }) async {
    //
    await FirebaseFirestore.instance
        .collection("Gyms")
        .where("gymId", isEqualTo: gymId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          "gymLocation": gymLocation,
          "gymName": gymName,
          "gymDescription": gymDescription,
          "gymAddress": gymAddress,
          "gymNumber": gymNumber,
          "startingPrice": startingPrice,
          "gymPackages": packages,
          "gymEmail": FirebaseAuth.instance.currentUser!.email,
        });
      });
    });
  }
}
