import 'package:bgmfitness/ViewModels/Vendor/nutritionist_provider.dart';
import 'package:bgmfitness/views/SellerPages/edit_gym_page.dart';
import 'package:bgmfitness/views/SellerPages/edit_nutritionist_page.dart';
import 'package:bgmfitness/views/SellerPages/edit_product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../ViewModels/Vendor/product_provider.dart';
import '../../constants.dart';

class SellerDirectoryPage extends StatefulWidget {
  const SellerDirectoryPage({Key? key}) : super(key: key);

  @override
  State<SellerDirectoryPage> createState() => _SellerDirectoryPageState();
}

class _SellerDirectoryPageState extends State<SellerDirectoryPage> {
  final Stream<QuerySnapshot> gymStream = FirebaseFirestore.instance
      .collection('Gyms')
      .where('gymUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('Products')
      .where('sellerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> nutritionistStream = FirebaseFirestore.instance
      .collection('Nutritionists')
      .where('nutritionistsUID',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Listings'),
        ),
        // drawer: const VendorDrawer(),
        body: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: "Gyms",
                  icon: Icon(
                    Icons.sports_gymnastics,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  text: "Products",
                  icon: Icon(
                    Icons.production_quantity_limits_sharp,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  text: "Nutitionists",
                  icon: Icon(
                    Icons.nature_people,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildGymTab(),
                  buildProductTab(),
                  buildNutritionistTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildGymTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: gymStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor),
            ),
          );
        }

        return snapshot.data!.docs.isEmpty
            ? const Center(
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data['gymImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['gymName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['gymFeedback'] == 0
                                        ? 0
                                        : (data['gymRating'] /
                                                (5 * data['gymFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Gym'),
                                        content: const Text(
                                            'Are you sure you want to delete this gym?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteGym(data['gymId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditGymPage(gymData: data),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildProductTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor),
            ),
          );
        }

        return snapshot.data!.docs.isEmpty
            ? const Center(
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data!['productImages'][0],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['productName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['productFeedback'] == 0
                                        ? 0
                                        : (data['productRating'] /
                                                (5 * data['productFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Product'),
                                        content: const Text(
                                            'Are you sure you want to delete this product?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteProduct(data['productId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductEditPage(
                                              productData: data)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  //
  StreamBuilder<QuerySnapshot<Object?>> buildNutritionistTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: nutritionistStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).indicatorColor),
            ),
          );
        }

        return snapshot.data!.docs.isEmpty
            ? const Center(
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data['nutritionistsImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['nutritionistsName']),
                                  // RatingBar.builder(
                                  //   itemSize: 20,
                                  //   ignoreGestures: true,
                                  //   itemBuilder: (context, index) => const Icon(
                                  //     Icons.star,
                                  //     size: 20,
                                  //     color: Colors.amber,
                                  //   ),
                                  //   itemCount: 5,
                                  //   initialRating: data['productFeedback'] == 0
                                  //       ? 0
                                  //       : (data['productRating'] /
                                  //               (5 * data['productFeedback'])) *
                                  //           5,
                                  //   unratedColor: Colors.grey,
                                  //   maxRating: 5,
                                  //   allowHalfRating: true,
                                  //   onRatingUpdate: (value) {},
                                  // ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title:
                                            const Text('Delete Nutritionist'),
                                        content: const Text(
                                            'Are you sure you want to delete this Nutritionist?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteNutritionist(
                                                  data['nutritionistsId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditNutritionistPage(
                                                  nutritionistData: data)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
