import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String leading;
  String title;
  String? suffix;
  bool isBack;
  bool isTitle;
  bool isSuffix;
  void Function()? suffixTap;
  CustomAppBar(
      {required this.leading,
      required this.title,
      this.suffix,
      this.isBack = false,
      this.isTitle = false,
      this.isSuffix = true,
      this.suffixTap});

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, statusBarColor: Colors.white);
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarBrightness: Brightness.dark,
      //     statusBarColor: Colors.white
      // ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10.0),
        ),
      ),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          print("back");
          if (isBack) {
            Get.back();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
        child: Builder(
          builder: (context) => isBack
              ? IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: SvgPicture.asset(
                      leading,
                      width: 20,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    print("bak tap");
                    Get.back();
                  },
                )
              : IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      leading,
                      width: 20,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
        ),
      ),
      title: isTitle
          ? Text(
              title,
              style: openSansExtraBold.copyWith(color: Colors.black),
            )
          : SizedBox(
              height: 20,
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1, child: Image.asset(r'assets/image/icon.png')),
                  const Flexible(
                      flex: 2,
                      child: Text('knawNews',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),

      //:SvgPicture.asset(title,width: 100,),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        //Image.asset(Images.filter, width: 20,),
        isSuffix
            ? GestureDetector(
                onTap: suffixTap,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    suffix!,
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              )
            : const SizedBox(),
      ],
      // flexibleSpace: Container(
      //   alignment: Alignment.centerRight,
      //   height: 100,
      //   decoration: BoxDecoration(
      //     color: Colors.red,
      //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Image.asset(Images.filter, width: 20,),
      //     ],
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.WEB_MAX_WIDTH, 60);
}
