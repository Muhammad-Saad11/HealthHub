import 'package:bgmfitness/views/CustomerPages/customer_bottom_nav_bar.dart';
import 'package:bgmfitness/views/CustomerPages/customer_main_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../Models/Order.dart';
import '../../payment_config.dart';
import '../../providerclass.dart';

class SingleOrderReview extends StatefulWidget {
  final paddress;
  final pcity;
  final pstate;
  final pphone;
  final ppostalcode;
  ProductOrder order;
  SingleOrderReview(
      {Key? key,
      this.paddress,
      this.pcity,
      this.pphone,
      this.ppostalcode,
      this.pstate,
      required this.order})
      : super(key: key);

  @override
  State<SingleOrderReview> createState() => _SingleOrderReviewState();
}

class _SingleOrderReviewState extends State<SingleOrderReview> {
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
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Image(image: NetworkImage(widget.order.ProductImages[0])),
                  title: Text(widget.order.ProductName),
                  subtitle:
                      Text('Quantity : ' + '${widget.order.ProductQuantity}'),
                  trailing: Text('${widget.order.ProductPrice}' + ' Rs'),
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
                Text(
                    '${widget.order.deliveryCharges + (widget.order.ProductPrice * widget.order.ProductQuantity)}'
                    ' Rs')
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
                    amount: (widget.order.deliveryCharges +
                            (widget.order.ProductPrice *
                                widget.order.ProductQuantity))
                        .toString(),
                    status: PaymentItemStatus.final_price),
              ],
              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) async {
                debugPrint("Results: ${result.toString()}");
                try {
                  var orderList = [];
                  orderList.add({
                    'ProductImage': widget.order.ProductImages[0],
                    'ProductName': widget.order.ProductName,
                    'ProductQuantity': widget.order.ProductQuantity,
                    'size': widget.order.Productcategory,
                    'buyerId': widget.order.buyerId,
                    'sellerId': widget.order.sellerId,
                    'deliveryCharges': widget.order.deliveryCharges,
                    'totalAmount': widget.order.deliveryCharges +
                        (widget.order.ProductPrice *
                            widget.order.ProductQuantity),
                  });
                  var vendor = [widget.order.sellerId];
                  Provider.of<ProductProvider>(context, listen: false)
                      .placeSingleOrder(
                          address: widget.paddress,
                          city: widget.pcity,
                          state: widget.pstate,
                          postalcode: widget.ppostalcode,
                          phone: widget.pphone,
                          price: widget.order.deliveryCharges +
                              (widget.order.ProductPrice *
                                  widget.order.ProductQuantity),
                          orderList: orderList,
                          vendor: vendor);

                  showAlert();
                  await Future.delayed(Duration(milliseconds: 2000));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => CustomerHomePage()));

                  // Navigator.pop(context);
                  // Navigator.pop(context);
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
