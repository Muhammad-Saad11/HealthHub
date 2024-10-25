// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intl/intl.dart';
//
// import '../../constants.dart';
// import 'details_screen.dart';
//
// class VenueViewAll extends StatelessWidget {
//   const VenueViewAll({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final money = NumberFormat("#,##0", "en_US");
//     final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
//         .collection('Venues')
//         .where('isPrivate', isEqualTo: false)
//         .snapshots();
//     double rating;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Venues'),
//         centerTitle: true,
//         backgroundColor: kPink,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: usersStream,
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                     Theme.of(context).primaryColor),
//               ),
//             );
//           }
//
//           return SizedBox(
//             child: ListView.separated(
//               separatorBuilder: (context, index) => const SizedBox(
//                 height: 0,
//               ),
//               physics: const ClampingScrollPhysics(),
//               shrinkWrap: true,
//               scrollDirection: Axis.vertical,
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var data = snapshot.data?.docs[index];
//                 return Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                   child: InkWell(
//                     onTap: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailsScreen(
//                             imageUrlList: data['venueImages'],
//                             title: data['venueName'],
//                             address: data['venueAddress'],
//                             description: data['venueDescription'],
//                             price: data['venuePrice'],
//                             isFav: false,
//                             contact: data['vendorNumber'],
//                             inactiveDates: data['inActiveDates'],
//                             vendorUID: data['vendorUID'],
//                             venueId: data['venueId'],
//                             menuMap: data['menus'],
//                             email: data['vendorEmail'],
//                             parking: data['venueParking'],
//                             capacity: data['venueCapacity'],
//                           ),
//                         ),
//                       );
//                     },
//                     child: Material(
//                       elevation: 2,
//                       child: ListTile(
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Image.network(
//                             data!['venueImages'][0],
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         title: Text(data['venueName']),
//                         subtitle:  RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "Per Person Rs.${money.format(data['venuePrice'])}",
//                                 style: TextStyle(
//                                   color: kPurple,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         trailing: RatingBar.builder(
//                           itemSize: 20,
//                           ignoreGestures: true,
//                           itemBuilder: (context, index) => Icon(
//                             Icons.star,
//                             size: 20,
//                             color: Colors.amber,
//                           ),
//                           itemCount: 5,
//                           initialRating: data['venueFeedback']==0? 0 :(data['venueRating'] / (5 * data['venueFeedback'])) * 5,
//                           unratedColor: Colors.grey,
//                           maxRating: 5,
//                           allowHalfRating: true,
//                           onRatingUpdate: (value) {
//                             rating = (data['venueRating'] / (5 * data['venueFeedback'])) * 5;
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//
//     );
//   }
// }
