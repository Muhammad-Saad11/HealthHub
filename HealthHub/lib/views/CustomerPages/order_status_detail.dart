import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../ViewModels/order_place_details.dart';
import '../../constants.dart';
import 'order_status.dart';

var cancelled=false;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({Key? key, this.data}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancelled= widget.data['order_cancelled'];
  }
  @override
  Widget build(BuildContext context) {
    var dt= widget.data['order_date'] as Timestamp;
    var lis=widget.data['orderlist'] as List;
    var data= widget.data as DocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
      ),
      body: ListView(

        children: [
          widget.data['order_cancelled'] == true || cancelled == true ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Order Cancelled',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red),)),
          ) : Column(
            children: [
              orderStatus(
                  color: Colors.black,
                  icon: Icons.done,
                  title: "Order placed",
                  showDone: widget.data['order_placed']
              ),
              orderStatus(
                  color: Colors.black,
                  icon: Icons.thumb_up_alt_sharp,
                  title: "Order Confirmed",
                  showDone: widget.data['order_confirmed']
              ),
              orderStatus(
                  color: Colors.black,
                  icon: Icons.local_shipping_outlined,
                  title: "On Delivery",
                  showDone: widget.data['order_on_delivery']
              ),
              orderStatus(
                  color: Colors.black,
                  icon: Icons.done_all,
                  title: "Order Delivered",
                  showDone: widget.data['order_delivered']
              ),
            ],
          ),
          cancelled == true || widget.data['order_confirmed'] == true || widget.data['order_cancelled'] == true  ? Container() : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white
              ),
                onPressed: ()async{
              await FirebaseFirestore.instance.collection('orders').doc(data.id).update({
                'order_cancelled':true,
              });
              setState(() {
                cancelled=true;
              });
            }, child: Text('Cancel order')),
          ),

          Divider(),
         SizedBox(
           height: 10,
         ),

         orderplaceDetails(
             d1: widget.data['order_id'],
             d2: widget.data['payment_method'],
             t1: "Order Code",
             t2: "Payment method"
         ),
         orderplaceDetails(
             d1: intl.DateFormat().add_yMd().format(dt.toDate()) ,
             d2: intl.DateFormat().add_jm().format(dt.toDate()),
             t1: "Order Date",
             t2: "Order Time"
         ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
           child: Row(
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Shipping Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                   Text('${widget.data['buyer_email']}'),
                   Text('${widget.data['buyer_address']}'),
                   Text('${widget.data['buyer_city']}'),
                   Text('${widget.data['buyer_state']}'),
                   Text('${widget.data['buyer_phone']}'),
                   Text('${widget.data['buyer_postalcode']}'),
                 ],
               ),


             ],
           ),


         ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Total Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                Text('${widget.data['total_amount']} Rs')
              ],
            ),
          ),
          Divider(),
      // ListTile(
      //           leading: Image(image: NetworkImage(data['orderlist'][0]['ProductImage'])),
      //           title: Text(data['orderlist'][0]['ProductName'].toString()),
      //           subtitle: Text(data['orderlist'][0]['ProductQuantity'].toString()),
      //           trailing: Text(data['orderlist'][0]['totalAmount'].toString()+' Rs'),
      //         )
          ListView.builder(
           // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: lis.length,
              itemBuilder: (context,index) {
                return ListTile(
                  leading: Image(image: NetworkImage(widget.data['orderlist'][index]['ProductImage'])),
                  title: Text(widget.data['orderlist'][index]['ProductName'].toString()),
                  subtitle: Text('Quantity : '+ widget.data['orderlist'][index]['ProductQuantity'].toString()),
                  trailing: Text(widget.data['orderlist'][index]['totalAmount'].toString()+' Rs'),
                );
              }
              )
        ],
      ),
    );
  }
}
