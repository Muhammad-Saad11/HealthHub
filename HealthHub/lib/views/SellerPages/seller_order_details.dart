import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_time_patterns.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/order_place_details.dart';
import '../../constants.dart';
import '../../providerclass.dart';

var orderConfirmed = false;
var orderOnDel = false;
var orderDelivered = false;
var cancelled= false;

class SellerOrderDetails extends StatefulWidget {
  final dynamic data;
  const SellerOrderDetails({Key? key, this.data}) : super(key: key);

  @override
  State<SellerOrderDetails> createState() => _SellerOrderDetailsState();
}

class _SellerOrderDetailsState extends State<SellerOrderDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductProvider>(context,listen: false).getSameVendorOrders(widget.data);
    status.getStatus(widget.data);
    orderConfirmed = widget.data['order_confirmed'];
    orderOnDel = widget.data['order_on_delivery'];
    orderDelivered = widget.data['order_delivered'];
    cancelled = widget.data['order_cancelled'];
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
          widget.data['order_cancelled'] == true || cancelled == true? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Order Cancelled',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red),)),
          ):   Column(
            children: [


           SwitchListTile(
                  title: Text('Order Placed',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  value: true,
                  onChanged: (val){
                  }
              ),
              SwitchListTile(
                  title: Text('Order Confirmed',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  value: status.confirmed,
                  onChanged: (val){

                    if(widget.data['order_confirmed']== false && orderConfirmed == false){
                      status.confirmed=val;
                      status.changeStatus(
                          title: 'order_confirmed',
                          status: val,
                          docId: data.id
                      );
                      setState(() {
                        orderConfirmed = true;
                      });
                    }
                    }

              ),
              SwitchListTile(
                  title: Text('On Delivery',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  value: status.onDelivery,
                  onChanged: (val){

                    if(orderConfirmed== true  && widget.data['order_on_delivery'] == false && orderOnDel == false){
                      status.onDelivery=val;
                      status.changeStatus(
                          title: 'order_on_delivery',
                          status: val,
                          docId: data.id
                      );
                      setState(() {
                        orderOnDel = true;
                      });
                    }

                  }
              ),
              SwitchListTile(
                  title: Text('Order Delivered',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  value: status.delivered,
                  onChanged: (val){

                    if(orderConfirmed== true  && orderOnDel == true && widget.data['order_delivered'] == false && orderDelivered == false ){
                      status.delivered=val;
                      status.changeStatus(
                          title: 'order_delivered',
                          status: val,
                          docId: data.id
                      );
                      setState(() {
                        orderDelivered = true;
                      });
                    }


                  }
              ),
            ],
          ),
          cancelled == true || widget.data['order_confirmed'] == true || widget.data['order_cancelled'] == true || orderConfirmed == true ? Container() : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{
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
              itemCount: Provider.of<ProductProvider>(context).orders.length,
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

class status{
  static var confirmed=false;
  static var onDelivery=false;
  static var delivered=false;
  static getStatus(data){
    confirmed=data['order_confirmed'];
    onDelivery = data['order_on_delivery'];
    delivered = data['order_delivered'];
  }

  static changeStatus({title,status,docId}) async {
    var store = FirebaseFirestore.instance.collection('orders').doc(docId);
    await store.set({
      title:status
    },
        SetOptions(
            merge: true
        )
    );
  }
}
