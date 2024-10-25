import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'genRandomString.dart';

class NutritionistProvider {
  String salonId = getRandomString();

  void addNutritionistData({
    required List nutritionistImages,
    required String nutritionistLocation,
    required String nutritionistName,
    required String nutritionistDescription,
    required String nutritionistAddress,
    required int nutritionistRating,
    required int nutritionistFeedback,
    required String nutritionistNumber,
    required List inActiveDates,
    required int startingPrice,
    required Map<String, int> packages,
  }) async {
    await FirebaseFirestore.instance
        .collection("Nutritionists")
        .doc(salonId)
        .set({
      "nutritionistsId": salonId,
      "nutritionistsImages": nutritionistImages,
      "nutritionistsLocation": nutritionistLocation,
      "nutritionistsName": nutritionistName,
      "nutritionistsDescription": nutritionistDescription,
      "nutritionistsAddress": nutritionistAddress,
      "nutritionistsUID": FirebaseAuth.instance.currentUser!.uid,
      "nutritionistsRating": nutritionistRating,
      "nutritionistsFeedback": nutritionistFeedback,
      "nutritionistsNumber": nutritionistNumber,
      "inActiveDates": inActiveDates,
      "startingPrice": startingPrice,
      "nutritionistsPackages": packages,
      "isPrivate": false,
      "nutritionistsEmail": FirebaseAuth.instance.currentUser!.email,
    });
  }
  void updateNutritionistData({
    required String nutritionistId,
    required String nutritionistLocation,
    required String nutritionistName,
    required String nutritionistDescription,
    required String nutritionistAddress,
    required String nutritionistNumber,
    required List inActiveDates,
    required int startingPrice,
    required Map<String, int> packages,
  }) async {

    await FirebaseFirestore.instance
        .collection("Nutritionists")
        .where("nutritionistsId", isEqualTo: nutritionistId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          "nutritionistsAddress": nutritionistAddress,
          "nutritionistsName": nutritionistName,
          "nutritionistsPackages": packages,
          "nutritionistsDescription": nutritionistDescription,
          "nutritionistsNumber": nutritionistNumber,
          "inActiveDates": inActiveDates,
          "startingPrice": startingPrice,
          "nutritionistsPackages": packages,
          "nutritionistsEmail": FirebaseAuth.instance.currentUser!.email,
        });
      });
    });

  }
}

