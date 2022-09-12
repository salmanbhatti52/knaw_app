import 'package:flutter/material.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/styles.dart';

class DotNews extends StatelessWidget {
  String text;
  DotNews({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          height: 7,
          width: 7,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
          ),
        ),
        Expanded(child: Text(text,style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall),)),
        // ListTile(
        //   minVerticalPadding: 0,
        //   minLeadingWidth: 0,
        //   leading: Container(
        //     height: 7,
        //     width: 7,
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.black
        //     ),
        //   ),
        //   title: Text(text,style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
        // ),
      ],
    );
  }
}
