import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Admin/admin_functions.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../Messenger Screens/chat_screen.dart';

late ChatUser me;
class VendorDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot userData;
  const VendorDetailsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Details'),
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
            const Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Address'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Business Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['BusinessName'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Role:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Role'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Number:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Number'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Request Status:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['RequestStatus'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            SizedBox(
              height: 15,
            ),
            userData['RequestStatus'] == "waiting" ||
                userData['RequestStatus'] == "rejected"? Container():Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black
                  ),
                  onPressed: () async {
                print('hjvjhvjvkjhvk : '+userData['Id']);
                APIs.addChatUser(userData['Email']);
                await FirebaseFirestore.instance
                    .collection('Accounts')
                    .doc(userData['Id'])
                    .get()
                    .then((user) async {
                  if (user.exists) {
                    me = ChatUser.fromJson(user.data()!);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChatScreen(user: me)));
                  }
                });
              }, child: Text('Send Message')),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black
                ),
                    onPressed: userData['RequestStatus'] == "waiting" ||
                            userData['RequestStatus'] == "rejected"
                        ? () {
                            updateRequestStatus(
                                vendorUId: userData['Id'],
                                requestStatus: 'approved');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black
                    ),
                    onPressed: userData['RequestStatus'] == "approved"
                        ? () {
                            updateRequestStatus(
                                vendorUId: userData['Id'],
                                requestStatus: 'rejected');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
