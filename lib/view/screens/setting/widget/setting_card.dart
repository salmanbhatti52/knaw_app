import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/util/styles.dart';

class SettingCard extends StatelessWidget {
  String icon;
  String title;
  void Function()? onTap;
  SettingCard({required this.icon,required this.title,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 30,),
            SvgPicture.asset(icon,width: 18,height: 18,),
            SizedBox(width: 10,),
            Text(title,style: openSansBold.copyWith(color: Colors.black,),),
          ],
        ),
      ),
    );
  }
}
