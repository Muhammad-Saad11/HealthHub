import 'package:bgmfitness/views/CustomerPages/customer_bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../constants.dart';
import '../../payment_config.dart';
import '../../providerclass.dart';

class OrderReview extends StatefulWidget {
  final paddress;
  final pcity;
  final pstate;
  final pphone;
  final ppostalcode;

  OrderReview(
      {Key? key,
      this.paddress,
      this.pcity,
      this.pphone,
      this.ppostalcode,
      this.pstate})
      : super(key: key);

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Order Placed',
        text: 'Order Placed Successfully',
        showCancelBtn: false,
      );
    }

    var prov = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Review'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: prov.cartList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image(
                      image: NetworkImage(prov.cartList[index].ProductImages)),
                  title: Text(prov.cartList[index].ProductName),
                  subtitle: Text('Quantity : ' +
                      '${prov.cartList[index].ProductQuantity}'),
                  trailing:
                      Text('${prov.cartList[index].ProductPrice}' + ' Rs'),
                );
              }),

          Divider(),
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(FirebaseAuth.instance.currentUser!.email.toString()),
                    Text(widget.paddress),
                    Text(widget.pcity),
                    Text(widget.pstate),
                    Text(widget.pphone),
                    Text(widget.ppostalcode),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Total Amount',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${prov.getTotalAmount() + prov.getTotalDelivery()}' ' Rs')
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
            child: GooglePayButton(
              paymentConfiguration:
                  PaymentConfiguration.fromJsonString(defaultGooglePay),
              paymentItems: [
                PaymentItem(
                    label: 'Order',
                    amount: (prov.getTotalAmount() + prov.getTotalDelivery())
                        .toString(),
                    status: PaymentItemStatus.final_price),
              ],
              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) async {
                debugPrint("Results: ${result.toString()}");
                try {
                  Provider.of<ProductProvider>(context, listen: false)
                      .getProductDetails();
                  Provider.of<ProductProvider>(context, listen: false)
                      .placeOrder(
                          address: widget.paddress,
                          city: widget.pcity,
                          state: widget.pstate,
                          postalcode: widget.ppostalcode,
                          phone: widget.pphone);
                  Provider.of<ProductProvider>(context, listen: false)
                      .cartList = [];
                  showAlert();
                  await Future.delayed(Duration(milliseconds: 2000));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => CustomerHomePage()));
                } catch (error) {
                  debugPrint("Payment request Error: ${error.toString()}");
                }
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (error) {
                debugPrint("Payment Error: ${error.toString()}");
              },
            ),
          ),
        ],
      ),
    );
  }
}
