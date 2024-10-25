import 'package:bgmfitness/views/SellerPages/seller_booking_page.dart';
import 'package:bgmfitness/views/SellerPages/seller_inProgress_orders.dart';
import 'package:bgmfitness/views/SellerPages/seller_appointment_page.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings and Orders'),
        ),
        // drawer: const VendorDrawer(),
        body: Column(
          children: const [
            TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.menu_book,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.brush,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.shopify,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SellerBookingPage(),
                  SellerAppointmentPage(),
                  InProgressSellerOrders(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
