import 'package:bgmfitness/views/SellerPages/seller_order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../../providerclass.dart';

class InProgressSellerOrders extends StatefulWidget {
  const InProgressSellerOrders({Key? key}) : super(key: key);

  @override
  State<InProgressSellerOrders> createState() => _InProgressSellerOrdersState();
}

class _InProgressSellerOrdersState extends State<InProgressSellerOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In Progress'),
        centerTitle: true,

      ),
      body: StreamBuilder(
          stream: Provider.of<ProductProvider>(context).getInProgressVendorOrders(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(child: Text('No Orders Yet'));
            }
            else{
              dynamic data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context,int index){
                    var d= data[index]['order_date'] as Timestamp;
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(15),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellerOrderDetails(data: data[index],)
                                ),
                              );
                            },

                            leading: Image(image: NetworkImage(data[index]['orderlist'][0]['ProductImage'])),
                            title: Text('Order Id : '+data[index]['order_id'].toString(),style: TextStyle(
                                color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16
                            ),),
                            subtitle: Text('Total Amount : '+data[index]['total_amount'].toString()+' Rs'),
                            trailing: Text('${intl.DateFormat().add_yMd().format(d.toDate())}'),
                          ),
                        )

                    );
                  }
              );
            }
          }
      ),
    );
  }
}
