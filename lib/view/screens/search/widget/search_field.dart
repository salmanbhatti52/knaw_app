import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  void Function(String val)? onChanged;
  SearchField({Key? key, required this.controller, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: AppData().language!.typeTopicToSearchNews,
        hintStyle: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft:Radius.circular(10) ), borderSide: BorderSide.none),
        filled: true, fillColor: const Color(0XFFF0F0F0),
        isDense: true,

        // suffixIcon: Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: SvgPicture.asset(Images.search,color: Theme.of(context).disabledColor),
        //   ),
      ),
    );
  }
}
