import 'package:cloud_firestore/cloud_firestore.dart';

updateRequestStatus({
  required String vendorUId,
  required String requestStatus,
}) async {
  await FirebaseFirestore.instance
      .collection('Vendor Requests')
      .doc(vendorUId)
      .update({
    'RequestStatus': requestStatus,
  });
}

updateAppointmentPaymentStatus({
  required String orderId,
  required String vendorUId,
  required String requestStatus,
}) async {
  var docRef = await FirebaseFirestore.instance
      .collection('Appointments')
      .where('nutritionistsUID', isEqualTo: vendorUId)
      .where('orderId', isEqualTo: orderId)
      .get();
  var id = docRef.docs.first.id;
  await FirebaseFirestore.instance
      .collection('Appointments')
      .doc(id)
      .update({
    'paymentStatus': requestStatus,
  });
}

updateGymPaymentStatus({
  required String orderId,
  required String vendorUId,
  required String requestStatus,
}) async {
  var docRef = await FirebaseFirestore.instance
      .collection('Gym Bookings')
      .where('gymUID', isEqualTo: vendorUId)
      .where('orderId')
      .get();
  var id = docRef.docs.first.id;
  await FirebaseFirestore.instance
      .collection('Gym Bookings')
      .doc(id)
      .update({
    'paymentStatus': requestStatus,
  });
}
