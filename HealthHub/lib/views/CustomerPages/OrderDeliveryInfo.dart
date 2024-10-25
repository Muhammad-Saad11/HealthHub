import 'package:flutter/material.dart';

import '../../constants.dart';
import 'order_review.dart';

String address = '';
String city = '';
String state = '';
String phone = '';
String postalcode = '';

class DeliveryDetails extends StatefulWidget {
  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  final formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro-SemiBold',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildAddress(),
              buildCity(),
              buildState(),
              buildPostalCode(),
              buildPhone(),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        // Provider.of<ProductProvider>(context, listen: false)
                        //     .getProductDetails();
                        // Provider.of<ProductProvider>(context, listen: false)
                        //     .placeOrder(
                        //     address: address,
                        //     city: city,
                        //     state: state,
                        //     postalcode: postalcode,
                        //     phone: phone);
                        // Provider
                        //     .of<ProductProvider>(context, listen: false)
                        //     .cartList = [];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderReview(
                                    paddress: address,
                                    pcity: city,
                                    pphone: phone,
                                    ppostalcode: postalcode,
                                    pstate: state,
                                  )),
                        );
                      } catch (error) {
                        debugPrint(
                            "Payment request Error: ${error.toString()}");
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Center(
                        child: const Text(
                          "   Place Order   ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Address",
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[#.0-9a-zA-Z\s,-]+$').hasMatch(value)) {
                  return "Enter your Address";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => address = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "City",
                labelText: "City",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[a-zA-Z\s,-]+$').hasMatch(value)) {
                  return "Enter your City";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => city = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "State",
                labelText: "State",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[a-zA-Z\s-]+$').hasMatch(value)) {
                  return "Enter your State";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => state = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPostalCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Postal Code",
                labelText: "Postal Code",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              // validator: (value) {
              //   if (value!.isEmpty ||
              //       !RegExp(r'^\d{5}(?:[-\s]\d{4})?$').hasMatch(value)) {
              //     return "Enter your PostalCode";
              //   } else {
              //     return null;
              //   }
              // },
              onSaved: (value) => setState(() => postalcode = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPhone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.white,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Phone Number",
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d{11}$").hasMatch(value)) {
                  return "Enter your Phone Number";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => phone = value!),
            ),
          ),
        ],
      ),
    );
  }
}
