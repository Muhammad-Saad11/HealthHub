import 'package:bgmfitness/ViewModels/Vendor/gym_functions.dart';
import 'package:bgmfitness/views/CustomerPages/customer_bottom_nav_bar.dart';
import 'package:bgmfitness/views/CustomerPages/nutritionists_request_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/Messenger Models/chat_user.dart';
import '../../ViewModels/Messenger Class/apis.dart';
import '../../constants.dart';
import '../../custom_app_bar.dart';
import '../../payment_config.dart';
import '../../providerclass.dart';
import '../Messenger Screens/chat_screen.dart';

class GymDetailsScreen extends StatefulWidget {
  final imageUrlList;
  final title;
  final address;
  final description;
  final price;
  final isFav;
  final contact;
  final gymUID;
  final gymId;
  final packagesMap;
  final email;

  GymDetailsScreen(
      {super.key,
      this.imageUrlList,
      this.title,
      this.address,
      this.description,
      this.price,
      this.isFav,
      this.contact,
      this.gymUID,
      this.gymId,
      this.packagesMap,
      this.email});

  @override
  _GymDetailsScreenState createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen> {
  int activeIndex = 0;
  int cost = 0;
  int? selectedCheckboxIndex;
  var days = [
    daysSelection(isSelected: true),
    daysSelection(),
    daysSelection()
  ];
  Map<String, int>? selectedPackage;

  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Booking Confirmed',
        text: 'Booking Confirmed Successfully',
        showCancelBtn: false,
      );
    }

    ProductProvider customerDetails = Provider.of<ProductProvider>(context);
    customerDetails.getCustomerDetails();
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
                  CarouselSlider.builder(
                    itemCount: widget.imageUrlList.length,
                    itemBuilder:
                        (BuildContext context, index, int pageViewIndex) {
                      final imageUrl = widget.imageUrlList[index];
                      return buildImage(imageUrl, index);
                    },
                    options: CarouselOptions(
                        height: size.height * 0.45,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index)),
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
                            bottom: 0,
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.address,
                          style: TextStyle(
                            fontSize: 15,
                            color: black.withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < days.length; i++) {
                                      days[i].isSelected = false;
                                    }
                                    days[0].isSelected = true;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      color: days[0].isSelected == true
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.r)),
                                  child: Center(
                                    child: Text(
                                      "30 Days",
                                      style: TextStyle(
                                          color: days[0].isSelected == true
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < days.length; i++) {
                                      days[i].isSelected = false;
                                    }
                                    days[1].isSelected = true;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      color: days[1].isSelected == true
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.r)),
                                  child: Center(
                                    child: Text(
                                      "60 Days",
                                      style: TextStyle(
                                          color: days[1].isSelected == true
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < days.length; i++) {
                                      days[i].isSelected = false;
                                    }
                                    days[2].isSelected = true;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      color: days[2].isSelected == true
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5.r)),
                                  child: Center(
                                    child: Text(
                                      "90 Days",
                                      style: TextStyle(
                                          color: days[2].isSelected == true
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gym information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // TextButton(
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => ProfilePage(
                              //                 nutritionistsUID: widget.nutritionistsUID)),
                              //       );
                              //     },
                              //     child: const Text("View Profile")),
                            ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Choose Your Package",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: const Text(
                                "Required",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SourceSansPro-SemiBold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Select one",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.packagesMap.length != null
                            ? ListView.separated(
                                physics: PageScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.packagesMap.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  String packageKey =
                                      widget.packagesMap.keys.elementAt(index);
                                  int value = widget.packagesMap[packageKey];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: kPink.withAlpha(50),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Package ${index + 1}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Radio(
                                                  activeColor: Colors.black,
                                                  value: index,
                                                  groupValue:
                                                      selectedCheckboxIndex,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      selectedCheckboxIndex =
                                                          value!;
                                                      cost = widget.packagesMap[
                                                          packageKey];
                                                      selectedPackage = {
                                                        packageKey: cost
                                                      };
                                                    });
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ExpandableText(
                                            packageKey,
                                            expandText: '\n\nShow More',
                                            collapseText: '\n\nShow Less',
                                            maxLines: 6,
                                            linkColor: kPurple,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: kPink.withOpacity(0.4),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Text(
                                              "Rs.  ${money.format(value)}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BottomButtons(
                          contact: widget.contact,
                          email: widget.email,
                          vendorId: widget.gymUID,
                        ),
                        SizedBox(
                          height: 140,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 60),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(),
                  ),
                ),
                height: 125,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: const Text(
                            "You Selected",
                            style: TextStyle(),
                          ),
                        ),
                        Text(
                          "Rs. ${cost * (days[2].isSelected ? 3 : days[1].isSelected ? 2 : 1)} Package",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    cost > 0
                        ? GooglePayButton(
                            paymentConfiguration:
                                PaymentConfiguration.fromJsonString(
                                    defaultGooglePay),
                            paymentItems: [
                              PaymentItem(
                                  label: 'Book',
                                  amount: (cost *
                                          (days[2].isSelected
                                              ? 3
                                              : days[1].isSelected
                                                  ? 2
                                                  : 1))
                                      .toString(),
                                  status: PaymentItemStatus.final_price),
                            ],
                            type: GooglePayButtonType.book,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: (result) async {
                              debugPrint("Results: ${result.toString()}");
                              try {
                                bookGym(
                                    payment: cost *
                                        (days[2].isSelected
                                            ? 3
                                            : days[1].isSelected
                                                ? 2
                                                : 1),
                                    gymId: widget.gymId,
                                    gymUID: widget.gymUID,
                                    days: days[2].isSelected
                                        ? 90
                                        : days[1].isSelected
                                            ? 60
                                            : 30,
                                    customerName: customerDetails.customer.Name,
                                    customerEmail:
                                        customerDetails.customer.Email,
                                    selectedPackage: selectedPackage!,
                                    gymName: widget.title,
                                    gymImg: widget.imageUrlList[0]);
                                showAlert();
                                await Future.delayed(
                                    Duration(milliseconds: 2000));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CustomerHomePage()));
                              } catch (error) {
                                debugPrint(
                                    "Payment request Error: ${error.toString()}");
                              }
                            },
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            onError: (error) {
                              debugPrint("Payment Error: ${error.toString()}");
                            },
                          )
                        : SizedBox(),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                    //   child: InkWell(
                    //     onTap: () {
                    //       selectedPackage == null
                    //           ? Fluttertoast.showToast(
                    //         msg: 'Please select a Package!',
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.BOTTOM,
                    //         timeInSecForIosWeb: 1,
                    //         backgroundColor: Colors.grey,
                    //         fontSize: 15,
                    //       )
                    //           :
                    //       bookGym(
                    //           payment: cost * (days[2].isSelected ? 3 : days[1].isSelected ? 2 : 1),
                    //           gymId: widget.gymId,
                    //           gymUID: widget.gymUID,
                    //           days: days[2].isSelected ? 90 : days[1].isSelected ? 60 : 30,
                    //           customerName: customerDetails.customer.Name,
                    //           customerEmail: customerDetails.customer.Email,
                    //           selectedPackage: selectedPackage!,
                    //           gymName: widget.title,
                    //           gymImg: widget.imageUrlList[0]
                    //       );
                    //
                    //     },
                    //     child: Container(
                    //       width: 150,
                    //       height: 50,
                    //       padding: const EdgeInsets.all(12),
                    //       decoration: BoxDecoration(
                    //         color: Colors.black,
                    //         borderRadius:
                    //         const BorderRadius.all(Radius.circular(10)),
                    //       ),
                    //       child: Center(
                    //         child: const Text(
                    //           "   Book   ",
                    //           style: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w700,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl, int index) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
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
                dotHeight: 14,
                dotWidth: 14,
                dotColor: Colors.white.withOpacity(0.6),
                activeDotColor: Colors.black),
          ),
        ),
      );
}

late ChatUser me;

class BottomButtons extends StatelessWidget {
  BottomButtons(
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

class daysSelection {
  bool isSelected;
  daysSelection({this.isSelected = false});
}
