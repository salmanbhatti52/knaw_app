import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CategoryItem extends StatelessWidget {
  String icon;
  bool isSelected;
  void Function()? onTap;

  CategoryItem({required this.icon,this.onTap,this.isSelected=false});

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(bottom: 5,top: 5,left: 5,right: 5),
        alignment: Alignment.center,
        // height: GetPlatform.isDesktop?70:50,
        // width: GetPlatform.isDesktop?60+length*8:50+length*6,
        decoration: BoxDecoration(
          color: Colors.white,
           shape: BoxShape.circle,
          border: Border.all(color:  isSelected?Colors.white:Colors.white,width: 3)
        ),
        child: Center(child: SvgPicture.asset(icon,width: 40,height: 40,)),
      ),
    );
  }
}
