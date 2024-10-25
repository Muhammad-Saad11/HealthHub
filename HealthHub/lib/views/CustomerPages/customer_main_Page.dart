import 'package:bgmfitness/views/CustomerPages/customer_bottom_nav_bar.dart';
import 'package:bgmfitness/views/CustomerPages/customer_drawer.dart';
import 'package:bgmfitness/views/CustomerPages/gym_details_page.dart';
import 'package:bgmfitness/views/CustomerPages/nutritionist_details_screen.dart';
import 'package:bgmfitness/views/CustomerPages/nutritionists_card.dart';
import 'package:bgmfitness/views/CustomerPages/productCard.dart';
import 'package:bgmfitness/views/CustomerPages/trainers_list_content/guest_list_main.dart';
import 'package:bgmfitness/views/CustomerPages/venue_view_all.dart';
import 'package:bgmfitness/views/SellerPages/seller_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providerclass.dart';
import 'details_screen.dart';
import 'item_Card.dart';

class CustomerMainPage extends StatefulWidget {
  const CustomerMainPage({Key? key}) : super(key: key);

  @override
  State<CustomerMainPage> createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("/////////dedededdededde///////");
  }

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
    print("/////////dedededdededde///////");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      drawer: CustomerDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                'Gym Planning tools',
                style: TextStyle(
                  fontFamily: 'SourceSansPro-SemiBold',
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ToolCard(
                    icon: Icons.checklist,
                    title: "Todo List",
                    color: Colors.black,
                    press: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomerHomePage(
                          val: 4,
                        );
                      }));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToolCard(
                    icon: Icons.assignment_ind,
                    title: "Videos",
                    color: Colors.black,
                    press: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TrainersList();
                      }));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToolCard(
                    icon: Icons.timer,
                    title: "Coming Soon",
                    color: Colors.black,
                    press: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Coming Soon',
                                style: TextStyle(
                                  fontFamily: 'SourceSansPro-SemiBold',
                                )),
                            content: const Text('This feature is coming soon.',
                                style: TextStyle(
                                  fontFamily: 'SourceSansPro-SemiBold',
                                )),
                            actions: [
                              TextButton(
                                child: const Text('OK',
                                    style: TextStyle(
                                      fontFamily: 'SourceSansPro-SemiBold',
                                      fontSize: 18,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 22,
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Whey Proteins',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('productCategory', isEqualTo: 'Whey Protein')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return SizedBox(
                  height: size.height * 0.32,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return DisplayCard(
                        context: context,
                        image: data!['productImages'][0],
                        title: data['productName'],
                        price: data['productPrice'],
                        totalRating: data['productRating'],
                        totalFeedbacks: data['productFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                imageUrlList: data['productImages'],
                                title: data['productName'],
                                address: data['productAddress'],
                                description: data['productDescription'],
                                price: data['productPrice'],
                                contact: data['sellerNumber'],
                                sellerUID: data['sellerUID'],
                                productId: data['productId'],
                                email: data['sellerEmail'],
                                category: data['productCategory'],
                                weight: data['productSize'],
                                deliveryCharges: data['productDelivery'],
                                availableQuantity: data['availableQuantity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amino acids',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('productCategory', isEqualTo: 'Amino')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return SizedBox(
                  height: size.height * 0.32,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return DisplayCard(
                        context: context,
                        image: data!['productImages'][0],
                        title: data['productName'],
                        price: data['productPrice'],
                        totalRating: data['productRating'],
                        totalFeedbacks: data['productFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                imageUrlList: data['productImages'],
                                title: data['productName'],
                                address: data['productAddress'],
                                description: data['productDescription'],
                                price: data['productPrice'],
                                contact: data['sellerNumber'],
                                sellerUID: data['sellerUID'],
                                productId: data['productId'],
                                email: data['sellerEmail'],
                                category: data['productCategory'],
                                weight: data['productSize'],
                                deliveryCharges: data['productDelivery'],
                                availableQuantity: data['availableQuantity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gym Accessories',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('productCategory', isEqualTo: 'Gym Acc')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return SizedBox(
                  height: size.height * 0.25,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return DisplayCard(
                        context: context,
                        image: data!['productImages'][0],
                        title: data['productName'],
                        price: data['productPrice'],
                        totalRating: data['productRating'],
                        totalFeedbacks: data['productFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                imageUrlList: data['productImages'],
                                title: data['productName'],
                                address: data['productAddress'],
                                description: data['productDescription'],
                                price: data['productPrice'],
                                contact: data['sellerNumber'],
                                sellerUID: data['sellerUID'],
                                productId: data['productId'],
                                email: data['sellerEmail'],
                                category: data['productCategory'],
                                weight: data['productSize'],
                                deliveryCharges: data['productDelivery'],
                                availableQuantity: data['availableQuantity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gyms for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Gyms')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return SizedBox(
                  height: size.height * 0.25,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10.w,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return DisplayCard(
                        context: context,
                        image: data!['gymImages'][0],
                        title: data['gymName'],
                        price: data['startingPrice'],
                        totalRating: data['gymRating'],
                        totalFeedbacks: data['gymFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GymDetailsScreen(
                                imageUrlList: data['gymImages'],
                                title: data['gymName'],
                                address: data['gymAddress'],
                                description: data['gymDescription'],
                                price: data['startingPrice'],
                                isFav: false,
                                contact: data['gymNumber'],
                                gymUID: data['gymUID'],
                                gymId: data['gymId'],
                                packagesMap: data['gymPackages'],
                                email: data['gymEmail'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nutritionists for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Nutritionists')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return SizedBox(
                  height: size.height * 0.25,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10.w,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return DisplayCard(
                        context: context,
                        image: data!['nutritionistsImages'][0],
                        title: data['nutritionistsName'],
                        price: data['startingPrice'],
                        totalRating: data['nutritionistsRating'],
                        totalFeedbacks: data['nutritionistsFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionistsDetailsScreen(
                                imageUrlList: data['nutritionistsImages'],
                                title: data['nutritionistsName'],
                                address: data['nutritionistsAddress'],
                                description: data['nutritionistsDescription'],
                                price: data['startingPrice'],
                                isFav: false,
                                contact: data['nutritionistsNumber'],
                                inactiveDates: data['inActiveDates'],
                                nutritionistsUID: data['nutritionistsUID'],
                                nutritionistId: data['nutritionistsId'],
                                packagesMap: data['nutritionistsPackages'],
                                email: data['nutritionistsEmail'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Venues for you',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>VenueViewAll()
            //             ),
            //           );
            //         },
            //         child: const Text(
            //           'View All',
            //           style: TextStyle(
            //             fontFamily: 'SourceSansPro-SemiBold',
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // StreamBuilder<QuerySnapshot>(
            //   stream: usersStream,
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('Something went wrong');
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           valueColor: AlwaysStoppedAnimation<Color>(
            //               Theme.of(context).primaryColor),
            //         ),
            //       );
            //     }
            //
            //     return SizedBox(
            //       height: size.height * 0.21,
            //       child: ListView.separated(
            //         separatorBuilder: (context, index) => const SizedBox(
            //           width: 15,
            //         ),
            //         physics: const ClampingScrollPhysics(),
            //         shrinkWrap: true,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context, index) {
            //           var data = snapshot.data?.docs[index];
            //           return ItemCard(
            //             context: context,
            //             image: data!['venueImages'][0],
            //             title: data['venueName'],
            //             price: data['venuePrice'],
            //             totalRating: data['venueRating'],
            //             totalFeedbacks: data['venueFeedback'],
            //             press: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => DetailsScreen(
            //                     imageUrlList: data['venueImages'],
            //                     title: data['venueName'],
            //                     address: data['venueAddress'],
            //                     description: data['venueDescription'],
            //                     price: data['venuePrice'],
            //                     isFav: false,
            //                     contact: data['vendorNumber'],
            //                     inactiveDates: data['inActiveDates'],
            //                     vendorUID: data['vendorUID'],
            //                     venueId: data['venueId'],
            //                     menuMap: data['menus'],
            //                     email: data['vendorEmail'],
            //                     parking: data['venueParking'],
            //                     capacity: data['venueCapacity'],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
            //
            // // not live data
            //
            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Jewelery for you',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //       builder: (context) =>JewleryViewAll()
            //           //   ),
            //           // );
            //         },
            //         child: const Text(
            //           'View All',
            //           style: TextStyle(
            //             fontFamily: 'SourceSansPro-SemiBold',
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // // StreamBuilder<QuerySnapshot>(
            // //   stream: jewleryStream,
            // //   builder: (BuildContext context,
            // //       AsyncSnapshot<QuerySnapshot> snapshot) {
            // //     if (snapshot.hasError) {
            // //       return Text('Something went wrong');
            // //     }
            // //
            // //     if (snapshot.connectionState == ConnectionState.waiting) {
            // //       return Center(
            // //         child: CircularProgressIndicator(
            // //           valueColor: AlwaysStoppedAnimation<Color>(
            // //               Theme.of(context).primaryColor),
            // //         ),
            // //       );
            // //     }
            // //
            // //     return SizedBox(
            // //       height: size.height * 0.21,
            // //       child: ListView.separated(
            // //         separatorBuilder: (context, index) => const SizedBox(
            // //           width: 15,
            // //         ),
            // //         physics: ClampingScrollPhysics(),
            // //         shrinkWrap: true,
            // //         scrollDirection: Axis.horizontal,
            // //         itemCount: snapshot.data!.docs.length,
            // //         itemBuilder: (context, index) {
            // //           var data = snapshot.data?.docs[index];
            // //           return ProductCard(
            // //             context: context,
            // //             image: data!['productImages'][0],
            // //             title: data['productName'],
            // //             price: data['productPrice'],
            // //             totalRating: data['productRating'],
            // //             totalFeedbacks: data['productFeedback'],
            // //             press: () {
            // //               // Navigator.push(
            // //               //   context,
            // //               //   MaterialPageRoute(
            // //               //     builder: (context) => JeweleryDetailsScreen(
            // //               //       imageUrlList: data['productImages'],
            // //               //       title: data['productName'],
            // //               //       address: data['productAddress'],
            // //               //       description: data['productDescription'],
            // //               //       price: data['productPrice'],
            // //               //       contact: data['sellerNumber'],
            // //               //       vendorUID: data['sellerUID'],
            // //               //       venueId: data['productId'],
            // //               //       email: data['sellerEmail'],
            // //               //       Carrots: data['productCarrots'],
            // //               //       tola: data['productSize'],
            // //               //       deliveryCharges: data['productDelivery'],
            // //               //       availableQuantity: data['availableQuantity'],
            // //               //     ),
            // //               //   ),
            // //               // );
            // //             },
            // //           );
            // //         },
            // //       ),
            // //     );
            // //   },
            // // ),
            //
            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Bridal Salon for you',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //       builder: (context) =>BridalViewAll()
            //           //   ),
            //           // );
            //         },
            //         child: const Text(
            //           'View All',
            //           style: TextStyle(
            //             fontFamily: 'SourceSansPro-SemiBold',
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('Bridal Salon')
            //       .where('category', isEqualTo: 'Bridal')
            //       .snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('Something went wrong');
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           valueColor: AlwaysStoppedAnimation<Color>(
            //               Theme.of(context).primaryColor),
            //         ),
            //       );
            //     }
            //
            //     return SizedBox(
            //       height: size.height * 0.21,
            //       child: ListView.separated(
            //         separatorBuilder: (context, index) => const SizedBox(
            //           width: 15,
            //         ),
            //         physics: const ClampingScrollPhysics(),
            //         shrinkWrap: true,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context, index) {
            //           var data = snapshot.data?.docs[index];
            //           return ProductCard(
            //             context: context,
            //             image: data!['salonImages'][0],
            //             title: data['salonName'],
            //             price: data['startingPrice'],
            //             totalRating: data['salonRating'],
            //             totalFeedbacks: data['salonFeedback'],
            //             press: () {
            //               // Navigator.push(
            //               //   context,
            //               //   MaterialPageRoute(
            //               //     builder: (context) => SalonDetailsScreen(
            //               //       imageUrlList: data['salonImages'],
            //               //       title: data['salonName'],
            //               //       address: data['salonAddress'],
            //               //       description: data['salonDescription'],
            //               //       price: data['startingPrice'],
            //               //       isFav: false,
            //               //       contact: data['vendorNumber'],
            //               //       inactiveDates: data['inActiveDates'],
            //               //       vendorUID: data['vendorUID'],
            //               //       venueId: data['salonId'],
            //               //       menuMap: data['salonPackages'],
            //               //       email: data['vendorEmail'],
            //               //     ),
            //               //   ),
            //               // );
            //             },
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
            //
            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Groom Salon for you',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //       builder: (context) => GroomViewAll()
            //           //   ),
            //           // );
            //         },
            //         child: const Text(
            //           'View All',
            //           style: TextStyle(
            //             fontFamily: 'SourceSansPro-SemiBold',
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('Bridal Salon')
            //       .where('category', isEqualTo: 'Groom')
            //       .snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('Something went wrong');
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           valueColor: AlwaysStoppedAnimation<Color>(
            //               Theme.of(context).primaryColor),
            //         ),
            //       );
            //     }
            //
            //     return SizedBox(
            //       height: size.height * 0.21,
            //       child: ListView.separated(
            //         separatorBuilder: (context, index) => const SizedBox(
            //           width: 15,
            //         ),
            //         physics: const ClampingScrollPhysics(),
            //         shrinkWrap: true,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context, index) {
            //           var data = snapshot.data?.docs[index];
            //           return ProductCard(
            //             context: context,
            //             image: data!['salonImages'][0],
            //             title: data['salonName'],
            //             price: data['startingPrice'],
            //             totalRating: data['salonRating'],
            //             totalFeedbacks: data['salonFeedback'],
            //             press: () {
            //               // Navigator.push(
            //               //   context,
            //               //   MaterialPageRoute(
            //               //     builder: (context) => SalonDetailsScreen(
            //               //       imageUrlList: data['salonImages'],
            //               //       title: data['salonName'],
            //               //       address: data['salonAddress'],
            //               //       description: data['salonDescription'],
            //               //       price: data['startingPrice'],
            //               //       isFav: false,
            //               //       contact: data['vendorNumber'],
            //               //       inactiveDates: data['inActiveDates'],
            //               //       vendorUID: data['vendorUID'],
            //               //       venueId: data['salonId'],
            //               //       menuMap: data['salonPackages'],
            //               //       email: data['vendorEmail'],
            //               //     ),
            //               //   ),
            //               // );
            //             },
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
            //
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'Dresses for you',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //       builder: (context) =>DressesViewAll()
            //           //   ),
            //           // );
            //         },
            //         child: Text(
            //           'View All',
            //           style: TextStyle(
            //             fontFamily: 'SourceSansPro-SemiBold',
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // // StreamBuilder<QuerySnapshot>(
            // //   stream: DressStream,
            // //   builder: (BuildContext context,
            // //       AsyncSnapshot<QuerySnapshot> snapshot) {
            // //     if (snapshot.hasError) {
            // //       return Text('Something went wrong');
            // //     }
            // //
            // //     if (snapshot.connectionState == ConnectionState.waiting) {
            // //       return Center(
            // //         child: CircularProgressIndicator(
            // //           valueColor: AlwaysStoppedAnimation<Color>(
            // //               Theme.of(context).primaryColor),
            // //         ),
            // //       );
            // //     }
            // //
            // //     return SizedBox(
            // //       height: size.height * 0.21,
            // //       child: ListView.separated(
            // //         separatorBuilder: (context, index) => const SizedBox(
            // //           width: 15,
            // //         ),
            // //         physics: ClampingScrollPhysics(),
            // //         shrinkWrap: true,
            // //         scrollDirection: Axis.horizontal,
            // //         itemCount: snapshot.data!.docs.length,
            // //         itemBuilder: (context, index) {
            // //           var data = snapshot.data?.docs[index];
            // //           return ProductCard(
            // //             context: context,
            // //             image: data!['productImages'][0],
            // //             title: data['productName'],
            // //             price: data['productPrice'],
            // //             totalRating: data['productRating'],
            // //             totalFeedbacks: data['productFeedback'],
            // //             press: () {
            // //               // Navigator.push(
            // //               //   context,
            // //               //   MaterialPageRoute(
            // //               //     builder: (context) => DressDetailsScreen(
            // //               //       imageUrlList: data['productImages'],
            // //               //       title: data['productName'],
            // //               //       address: data['productAddress'],
            // //               //       description: data['productDescription'],
            // //               //       price: data['productPrice'],
            // //               //       contact: data['sellerNumber'],
            // //               //       vendorUID: data['sellerUID'],
            // //               //       venueId: data['productId'],
            // //               //       email: data['sellerEmail'],
            // //               //       size: data['productSize'],
            // //               //       deliveryCharges: data['productDelivery'],
            // //               //       availableQuantity: data['availableQuantity'],
            // //               //     ),
            // //               //   ),
            // //               // );
            // //             },
            // //           );
            // //         },
            // //       ),
            // //     );
            // //   },
            // // ),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    // required this.image,
    required this.title,
    required this.color,
    required this.press,
    required this.icon,
  });

  // final String image, title;
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    color: color,
                    padding: const EdgeInsets.all(
                      kDefaultPadding / 2,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'SourceSansPro-SemiBold',
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
