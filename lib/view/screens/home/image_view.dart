import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:knaw_news/view/screens/auth/auth_screen.dart';
import 'package:knaw_news/view/screens/auth/sign_in_screen.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/inbox/inbox.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ImageView extends StatefulWidget {
  String? image;
  ImageView({Key? key,this.image}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(child: Image.asset(Images.back, width: 50,),onTap: () => Get.back(),),
      ),
      key: _globalKey,
      body: Image.network(
        widget.image??'',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
