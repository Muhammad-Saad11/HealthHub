import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../providerclass.dart';

class CartListTile extends StatelessWidget {
  CartListTile({this.lname = "", this.limage = "", this.lprice = 0, this.lquantity = 0,this.ldeliveryCharges=0,this.lcategory=''});

  String limage;
  String lname;
  String lcategory;
  int lprice;
  int lquantity;
  int ldeliveryCharges;

  @override
  Widget build(BuildContext context) {

    var myProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        shadowColor: kPink.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
                child: Container(
                  height: 85.h,
                  child: Image.network(
                    limage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  height: 100.h,
                  child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lname,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           SizedBox(
                            height: 2.h,
                          ),
                          Text(lcategory, style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),),
                           SizedBox(
                            height: 2.h,
                          ),
                          // Text(totalPrice!().toString() + ' Rs',
                          Text(lprice.toString() + ' Rs',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),)
                        ],
                      )
                  ),
                )
            ),
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                    height: 100.h,
                    child: Center(
                        child: Text('Quantity: ' + lquantity.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                          ),
                        )
                    ),
                      ),

                     SizedBox(
                      width: 10.w,
                    ),
                    Padding(
                      padding:  EdgeInsets.all(6.0.sp),
                      child: InkWell(
                          onTap: () {
                            bool check = false;
                            var ele;
                            myProvider.cartList.forEach((element) {
                              if (element.ProductName == lname) {
                                check = true;
                                ele = element;
                              }
                            });
                            if (check) {
                              myProvider.cartList.remove(ele);
                              myProvider.notifyListeners();
                              Fluttertoast.showToast(
                                msg: '$lname remove from cart',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.grey.shade900,
                                fontSize: 15,
                              );
                            }
                          },
                          child: Icon(Icons.delete)
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
