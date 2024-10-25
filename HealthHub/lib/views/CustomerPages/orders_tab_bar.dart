
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'order_history.dart';
import 'orders_inprogress.dart';

class CustomerOrderTabs extends StatelessWidget {
  const CustomerOrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          centerTitle: true,
        ),
        body: Column(
          children: const [
            TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.pending_actions,
                    color: Colors.black,
                  ),
                ),

                Tab(
                  icon: Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OrdersInProgress(),
                  OrderHistory()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
