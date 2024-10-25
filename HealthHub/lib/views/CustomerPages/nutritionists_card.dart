import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard({
    required this.image,
    required this.title,
    required this.price,
    required this.press,
    required this.context,
    required this.totalRating,
    required this.totalFeedbacks,
  });

  final String image, title;
  final int price;
  final VoidCallback press;
  final BuildContext context;
  final int totalRating;
  final int totalFeedbacks;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");
    double rating;
    return InkWell(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width*0.5,
        color: Color(0xD4FAFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: AspectRatio(
                  aspectRatio: 5/3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            RatingBar.builder(
              itemSize: 20,
              ignoreGestures: true,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                size: 20,
                color: Colors.amber,
              ),
              itemCount: 5,
              initialRating: totalFeedbacks==0? 0 :(totalRating / (5 * totalFeedbacks)) * 5,
              unratedColor: Colors.grey,
              maxRating: 5,
              allowHalfRating: true,
              onRatingUpdate: (value) {
                rating = (totalRating / (5 * totalFeedbacks)) * 5;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$title\n".toUpperCase(),
                        style: TextStyle(
                            fontFamily: 'SourceSansPro-SemiBold',
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: "Rs.${money.format(price)}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
