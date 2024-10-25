import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providerclass.dart';
import 'Cart_tile.dart';
import 'OrderDeliveryInfo.dart';

class ReviewCart extends StatelessWidget {
  const ReviewCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalDelivery=0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Cart',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Provider.of<ProductProvider>(context).cartList.isEmpty ? Center(child: Text("Cart is empty"),): Container(
        height: double.infinity,
        width: double.infinity,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(

              child: Container(
                child: ListView.builder(

                    itemCount: Provider.of<ProductProvider>(context).cartList.length,
                    itemBuilder: (context,index){
                      return CartListTile(
                        limage: Provider.of<ProductProvider>(context).cartList[index].ProductImages,
                        lname: Provider.of<ProductProvider>(context).cartList[index].ProductName,
                        lprice: Provider.of<ProductProvider>(context).cartList[index].totalPrice(),
                        lquantity: Provider.of<ProductProvider>(context).cartList[index].ProductQuantity,
                        lcategory: Provider.of<ProductProvider>(context).cartList[index].Productcategory ,
                      );
                    }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Delivery Charges : ${Provider.of<ProductProvider>(context).getTotalDelivery()} Rs',style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceSansPro-SemiBold',
                  ),),
                  Text('Total Amount : ${Provider.of<ProductProvider>(context).getTotalAmount()+Provider.of<ProductProvider>(context).getTotalDelivery()} Rs',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro-SemiBold',
                    ),)
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10),
              child: GestureDetector(
                onTap: () {
                  if(Provider.of<ProductProvider>(context,listen: false).cartList.isNotEmpty){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryDetails(
                          )
                      ),
                    );
                  }

                },
                child: Center(
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width-80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Center(
                      child: const Text(
                        "   Proceed   ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SourceSansPro-SemiBold',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: RoundedButton(colour: kPink.withOpacity(0.4), buttonTitle: 'Place Order', onPressedFunction: ()async{
            //     await Provider.of<ProductProvider>(context,listen: false).setcartdata();
            //     Provider.of<ProductProvider>(context,listen: false).cartList=[];
            //     Provider.of<ProductProvider>(context,listen: false).getCartData();
            //     Provider.of<ProductProvider>(context,listen: false).notifyListeners();
            //   }, Elevation: 10),
            // )
          ],
        ),
      ),
    );
  }
}
