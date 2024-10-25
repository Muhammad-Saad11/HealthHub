import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Models/Order.dart';
import 'Models/VendorRequest.dart';
import 'Models/bookings.dart';
import 'Models/customer.dart';
import 'ViewModels/Messenger Class/apis.dart';
import 'ViewModels/Vendor/product_provider.dart';
import 'google_login.dart';

class ProductProvider with ChangeNotifier {
  List<Booking> hallsList = [];
  late Booking halls;
  List<Requests> requestList = [];
  late Requests request;
  List<ProductOrder> cartList = [];
  List<ProductOrder> cartHistoryList = [];
  late ProductOrder cartHistory;
  var products = [];
  var vendors = [];
  var orders = [];

  void addToCart(String pname, int pprice, String pimage, int pquantity,
      int deliveryCost, String seller, String buyer, String category) {
    var cart = ProductOrder(
        ProductName: pname,
        ProductQuantity: pquantity,
        ProductPrice: pprice,
        ProductImages: pimage,
        deliveryCharges: deliveryCost,
        sellerId: seller,
        buyerId: buyer,
        Productcategory: category);
    cartList.add(cart);
  }

  getProductDetails() {
    for (int i = 0; i < cartList.length; i++) {
      products.add({
        'ProductImage': cartList[i].ProductImages,
        'ProductName': cartList[i].ProductName,
        'ProductQuantity': cartList[i].ProductQuantity,
        'size': cartList[i].Productcategory,
        'buyerId': cartList[i].buyerId,
        'sellerId': cartList[i].sellerId,
        'deliveryCharges': cartList[i].deliveryCharges,
        'totalAmount': cartList[i].totalPrice(),
      });

      vendors.add(cartList[i].sellerId.replaceAll('{', '').replaceAll('}', ''));
      payVendor(
          vendorUID: cartList[i].sellerId, payment: cartList[i].totalPrice());
      updateVendorStock(
          productName: cartList[i].ProductName,
          quantity: cartList[i].ProductQuantity);
    }
  }

  void searchUpdate(
      {required collection, required name, required quantity}) async {
    var ids = [];
    var data = await FirebaseFirestore.instance
        .collection(collection)
        .where('productName', isEqualTo: name)
        .get();
    for (int i = 0; i < data.size; i++) {
      ids.add(data.docs[i].id);
    }
    if (ids.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(ids[0])
          .update({'availableQuantity': FieldValue.increment(-quantity)});
    }
  }

  void updateVendorStock({
    required String productName,
    required int quantity,
  }) async {
    searchUpdate(
        collection: 'Jewelerys', name: productName, quantity: quantity);
    searchUpdate(collection: 'Dresses', name: productName, quantity: quantity);
  }

  int getTotalDelivery() {
    int cost = 0;
    for (int i = 0; i < cartList.length; i++) {
      cost = cost + cartList[i].deliveryCharges;
    }
    return cost;
  }

  int getTotalAmount() {
    int cost = 0;
    for (int i = 0; i < cartList.length; i++) {
      cost = cost + cartList[i].ProductPrice;
    }
    //cost = cost + getTotalAmount();
    return cost;
  }

  Future getCartData() async {
    List<ProductOrder> newlist = [];
    var basedata = await FirebaseFirestore.instance
        .collection("mycart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('reviewcart')
        .get();
    basedata.docs.forEach((element) {
      cartHistory = ProductOrder(
          ProductImages: element.get('imageAddress'),
          ProductName: element.get('name'),
          ProductPrice: element.get('price'),
          ProductQuantity: element.get('quantity'));
      newlist.add(cartHistory);
    });
    cartHistoryList = newlist;
    notifyListeners();
  }

  getSameVendorOrders(data) {
    orders.clear();
    for (var item in data['orderlist']) {
      if (item['sellerId'] == FirebaseAuth.instance.currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  getInProgressVendorOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('vendors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: false)
        .snapshots();
  }

  getCompletedVendorOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('vendors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: true)
        .snapshots();
  }

  Future placeOrder(
      {String address = '',
      String city = '',
      String state = '',
      String phone = '',
      String postalcode = ''}) async {
    var total_amount = getTotalAmount() + getTotalDelivery();
    await FirebaseFirestore.instance.collection('orders').doc().set({
      'order_id': Random().nextInt(10000000),
      'order_date': FieldValue.serverTimestamp(),
      'buyer_id': FirebaseAuth.instance.currentUser!.uid,
      'buyer_email': FirebaseAuth.instance.currentUser!.email,
      'buyer_address': address,
      'buyer_city': city,
      'buyer_state': state,
      'buyer_phone': phone,
      'buyer_postalcode': postalcode,
      'payment_method': 'GooglePay',
      'order_placed': true,
      'order_confirmed': false,
      'order_on_delivery': false,
      'order_delivered': false,
      'order_cancelled': false,
      'total_amount': total_amount,
      'orderlist': FieldValue.arrayUnion(products),
      'vendors': vendors
    });
  }
  Future placeSingleOrder(
      {String address = '',
        String city = '',
        String state = '',
        String phone = '',
        String postalcode = '',
        var price ,
        var orderList,
        var vendor
      }) async {
    await FirebaseFirestore.instance.collection('orders').doc().set({
      'order_id': Random().nextInt(10000000),
      'order_date': FieldValue.serverTimestamp(),
      'buyer_id': FirebaseAuth.instance.currentUser!.uid,
      'buyer_email': FirebaseAuth.instance.currentUser!.email,
      'buyer_address': address,
      'buyer_city': city,
      'buyer_state': state,
      'buyer_phone': phone,
      'buyer_postalcode': postalcode,
      'payment_method': 'GooglePay',
      'order_placed': true,
      'order_confirmed': false,
      'order_on_delivery': false,
      'order_delivered': false,
      'order_cancelled': false,
      'total_amount': price,
      'orderlist': orderList,
      'vendors': vendor
    });
  }
  getAllOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('buyer_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  getInProgressOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('buyer_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: false)
        .snapshots();
  }

  InProgressVendorOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('vendors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: false)
        .snapshots();
  }

  VendorCompletedOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('vendors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: true)
        .snapshots();
  }

  getComletedOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('buyer_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('order_delivered', isEqualTo: true)
        .snapshots();
  }


  getUserEmail() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  Future fetchRequests() async {
    var document =
        await FirebaseFirestore.instance.collection('Vendor Requests').get();
    for (var element in document.docs) {
      request = Requests(id: element.get('Id'), name: element.get('Name'));
      requestList.add(request);
    }
    notifyListeners();
  }

  Future updateQuantity() async {
    var document =
        await FirebaseFirestore.instance.collection('Vendor Requests').get();
    for (var element in document.docs) {
      request = Requests(id: element.get('Id'), name: element.get('Name'));
      requestList.add(request);
    }
    notifyListeners();
  }

  Future signOut() async {
    APIs.getSelfInfo();
    APIs.updateActiveStatus(false);
    if (await googleSignin.isSignedIn()) {
      await googleSignin.disconnect();
    }

    await FirebaseAuth.instance.signOut();
  }

  late Customer customer;
  Future getCustomerDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      customer = Customer(
        Name: snapshot.get('Name').toString(),
        Email: snapshot.get('Email').toString(),
      );
    }

    notifyListeners();
  }
}

Future signout() async {
  APIs.updateActiveStatus(false);
  if (await googleSignin.isSignedIn()) {
    await googleSignin.disconnect();
  }

  await FirebaseAuth.instance.signOut();
}

deleteDocument(String venueId) async {
  var document = await FirebaseFirestore.instance;
  document.collection("Venues").doc(venueId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}
