import 'package:flutter/material.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/about_model.dart';
import 'package:knaw_news/services/about_service.dart';

import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';

import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<AboutModel>? aboutModel;
  String about = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: CustomAppBar(
        leading: Images.menu,
        title: AppData().language!.about,
        isTitle: true,
        isSuffix: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Center(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                //about,
                'Social gateway to trending topics and trends organized into perfect categories for you to enjoy. Users manage content by rating posts by users, pushing posts into their most-voted emoji. Want to feel good? Check out the smiley posts. Want to fix the world\'s problems? Check out the angry emoji posts. Perhaps you want to feel warm and cuddly? Check the love heart posts. Content rated by the people for the people.',
                style: openSansRegular.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getAbout() async {
    openLoadingDialog(context, "Loading");
    aboutModel = AboutServices().get();
    print(aboutModel.toString());
    await aboutModel!.then((value) {
      if (value.status == "success") {
        about = value.data!;
        setState(() {});
      } else {
        setState(() {});
        //showCustomSnackBar(value.message??"");
      }
    });
    Navigator.pop(context);
  }
}
