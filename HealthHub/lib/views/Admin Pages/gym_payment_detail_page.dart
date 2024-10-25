import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ViewModels/Admin/admin_functions.dart';
import '../../constants.dart';

class GymPayment extends StatelessWidget {
  final QueryDocumentSnapshot userData;
  const GymPayment({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Material(
              elevation: 2,
              child: Table(
                border: TableBorder.all(color: kPurple),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Field',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Value',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildTableRow(
                      name: 'Booking Completed',
                      value: (userData['bookingEnds'] as Timestamp).toDate()),
                  buildTableRow(
                      name: 'bookingDate',
                      value: (userData['gymBookedOn'] as Timestamp).toDate()),
                  buildTableRow(
                      name: 'customerEmail', value: userData['customerEmail']),
                  buildTableRow(
                      name: 'customerName', value: userData['customerName']),
                  buildTableRow(name: 'orderId', value: userData['orderId']),
                  buildTableRow(
                      name: 'orderStatus', value: userData['orderStatus']),
                  buildTableRow(name: 'payment', value: userData['payment']),
                  buildTableRow(
                      name: 'paymentStatus', value: userData['paymentStatus']),
                  buildTableRow(name: 'gymId', value: userData['gymId']),
                  buildTableRow(name: 'gymName', value: userData['gymName']),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['paymentStatus'] == "onHold"
                        ? () {
                            updateGymPaymentStatus(
                                orderId: userData['orderId'],
                                vendorUId: userData['gymUID'],
                                requestStatus: 'onHoldByAdmin');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Block'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['paymentStatus'] == "onHoldByAdmin"
                        ? () {
                            updateGymPaymentStatus(
                                orderId: userData['orderId'],
                                vendorUId: userData['gymUID'],
                                requestStatus: 'onHold');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('UnBlock'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  TableRow buildTableRow({
    required name,
    required value,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name.toString().toTitleCase(),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value.toString().toTitleCase(),
            ),
          ),
        ),
      ],
    );
  }
}
