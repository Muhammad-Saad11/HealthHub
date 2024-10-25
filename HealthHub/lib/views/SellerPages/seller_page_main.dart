import 'package:bgmfitness/views/SellerPages/request_payments.dart';
import 'package:bgmfitness/views/SellerPages/seller_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class SellerMainPage extends StatefulWidget {
  const SellerMainPage({Key? key}) : super(key: key);

  @override
  State<SellerMainPage> createState() => _SellerMainPageState();
}

class _SellerMainPageState extends State<SellerMainPage> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "en_US");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"),
      ),
      drawer: SellerDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.20,
                child: Row(
                  children: [
                    buildOnHoldPayments(
                        numberFormat: numberFormat,
                        paymentStatus: 'readyPayments',
                        title: 'Total Payments'),
                    const SizedBox(
                      width: 12,
                    ),
                    buildOnHoldPayments(
                        numberFormat: numberFormat,
                        paymentStatus: 'onHoldPayments',
                        title: 'Pending Payments'),
                  ],
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const RequestPayments()));
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 30.w,vertical: 20.h),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20.h)
                    ),
                    child: Center(child: Text("Request Payments",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:FontWeight.bold,
                        fontSize: 16.sp,
                        fontFamily: "SourceSansPro-SemiBold"
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  Expanded buildOnHoldPayments({
    required NumberFormat numberFormat,
    required String paymentStatus,
    required String title,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Vendors')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }

                  final vendorData = snapshot.data!.data();
                  final payments = vendorData?[paymentStatus] as int?;

                  return Text(
                    'Rs.${numberFormat.format(payments)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> onHoldPayments({required String paymentStatus}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Vendor Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Venue Orders')
        .where("paymentStatus", isEqualTo: paymentStatus)
        .get();

    int totalPayment = 0;

    for (var doc in querySnapshot.docs) {
      final payment = doc.data()['payment'] as int?;
      if (payment != null) {
        totalPayment += payment;
      }
    }

    return totalPayment;
  }
}
