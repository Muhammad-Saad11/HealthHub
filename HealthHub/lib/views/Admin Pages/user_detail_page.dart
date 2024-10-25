import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot userData;
  const CustomerDetailsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Name'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Email'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
