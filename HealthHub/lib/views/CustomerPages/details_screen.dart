import 'package:bgmfitness/Models/Order.dart';
import 'package:bgmfitness/Models/product_model.dart';
import 'package:bgmfitness/views/CustomerPages/single_order_delivery_info.dart';
import 'package:bgmfitness/views/CustomerPages/vendor_profile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../constants.dart';
import '../../custom_app_bar.dart';
import '../../providerclass.dart';
import '../Messenger Screens/chat_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final imageUrlList;
  final title;
  final address;
  final description;
  final price;
  final contact;
  final sellerUID;
  final productId;
  final category;
  final weight;
  final deliveryCharges;
  final email;
  final availableQuantity;

  ProductDetailsScreen(
      {super.key,
      this.imageUrlList,
      this.title,
      this.address,
      this.description,
      this.price,
      this.deliveryCharges,
      this.category,
      this.weight,
      this.contact,
      this.sellerUID,
      this.productId,
      this.email,
      this.availableQuantity});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int cost = 0;
  int activeIndex = 0;
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final money = NumberFormat("#,##0", "en_US");

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  SafeArea(
                    child: CarouselSlider.builder(
                      itemCount: widget.imageUrlList.length,
                      itemBuilder:
                          (BuildContext context, index, int pageViewIndex) {
                        final imageUrl = widget.imageUrlList[index];
                        return buildImage(imageUrl, index);
                      },
                      options: CarouselOptions(
                          // autoPlay: true,
                          //   autoPlayInterval: Duration(seconds: 2),
                          height: size.height * 0.4,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.43),
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: appPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rs. ${money.format(widget.price)}',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SourceSansPro-SemiBold"),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.address,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: black.withOpacity(0.4),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "SourceSansPro-SemiBold"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Container(
                            height: 30,
                            child: Row(
                              children: [
                                Text(
                                  'Quantity : ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SourceSansPro-SemiBold"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantity < widget.availableQuantity) {
                                        quantity++;
                                      }
                                    });
                                  },
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        fontFamily: "SourceSansPro-SemiBold"),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    //padding: EdgeInsets.all(24),
                                  ),
                                ),
                                Text(' ${quantity}'),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 0) {
                                        quantity--;
                                      }
                                    });
                                  },
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      fontFamily: "SourceSansPro-SemiBold",
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    //padding: EdgeInsets.all(24),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Delivery Charges : ${widget.deliveryCharges} Rs',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SourceSansPro-SemiBold"),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Product information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              id: widget.sellerUID)),
                                    );
                                  },
                                  child: const Text("View Profile")),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Category : ${widget.category}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Weight : ${widget.weight}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: kDefaultPadding,
                          ),
                          child: ExpandableText(
                            widget.description,
                            expandText: '\nShow More',
                            collapseText: '\nShow Less',
                            maxLines: 4,
                            linkColor: kPurple,
                            style: TextStyle(
                              color: black.withOpacity(0.4),
                              height: 1.5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Contact Seller',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BottomButtons(
                          contact: widget.contact,
                          email: widget.email,
                          vendorId: widget.sellerUID,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(
                          height: 110,
                        )
                      ],
                    ),
                  ),
                  buildIndicator(),
                  CustomAppBar(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(),
                    ),
                  ),
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, right: 10),
                          child: InkWell(
                            onTap: () {
                              var item = ProductOrder(
                                ProductName: widget.title,
                                ProductPrice: widget.price,
                                ProductImages: widget.imageUrlList,
                                ProductQuantity: quantity,
                                Productcategory: widget.category,
                                deliveryCharges: widget.deliveryCharges,
                                sellerId: widget.sellerUID,
                                buyerId: FirebaseAuth.instance.currentUser!.uid,
                              );
                              if (quantity > 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleDeliveryDetails(order: item)),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Kindly Select Quantity',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey.shade900,
                                  fontSize: 15,
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: const Text(
                                  "   Place Order   ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, right: 10),
                          child: InkWell(
                            onTap: () {
                              if (quantity > 0) {
                                var prov = Provider.of<ProductProvider>(context,
                                    listen: false);
                                bool c = false;
                                prov.cartList.forEach((element) {
                                  if (element.ProductName == widget.title) {
                                    c = true;
                                    element.ProductQuantity =
                                        element.ProductQuantity + quantity;
                                    var total = element.ProductQuantity;
                                    Fluttertoast.showToast(
                                      msg:
                                          '${widget.title} added $total times in cart',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.grey.shade900,
                                      fontSize: 15,
                                    );
                                  }
                                });
                                if (!c) {
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .addToCart(
                                          widget.title,
                                          widget.price,
                                          widget.imageUrlList[0],
                                          quantity,
                                          widget.deliveryCharges,
                                          widget.sellerUID,
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.category);
                                  Fluttertoast.showToast(
                                    msg: '${widget.title} added in cart',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey.shade900,
                                    fontSize: 15,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Kindly Select Quantity',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey.shade900,
                                  fontSize: 15,
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: const Text(
                                  "   Add to Cart   ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl, int index) {
    return Container(
      // width: MediaQuery.of(context).size.width-20,
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildIndicator() => Positioned(
        left: 0,
        right: 0,
        top: MediaQuery.of(context).size.height * 0.39,
        child: Align(
          alignment: AlignmentDirectional.topCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: widget.imageUrlList.length,
            effect: JumpingDotEffect(
                dotHeight: 12,
                dotWidth: 12,
                dotColor: Colors.white.withOpacity(0.6),
                activeDotColor: Colors.black),
          ),
        ),
      );
}

late ChatUser me;

class BottomButtons extends StatelessWidget {
  const BottomButtons(
      {required this.contact, required this.email, required this.vendorId});

  final String contact;
  final String email;
  final String vendorId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            APIs.addChatUser(email);
            await FirebaseFirestore.instance
                .collection('Accounts')
                .doc(vendorId)
                .get()
                .then((user) async {
              if (user.exists) {
                me = ChatUser.fromJson(user.data()!);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ChatScreen(user: me)));
              }
            });
          },
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.mail_rounded),
                  color: white,
                ),
                Text(
                  ' Message',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _launchTel,
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.call_rounded),
                  color: white,
                ),
                Text(
                  ' Call',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchTel() async {
    if (!await launchUrl(Uri.parse("tel:$contact"))) {
      throw Exception('Could not launch $contact');
    }
  }
}
