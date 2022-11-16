<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/language_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_up_screen.dart';
import 'package:knaw_news/view/screens/auth/social_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: Container(
                  child: Column(children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      Images.logo_name_vertical,
                      width: 150,
                    ),
                    const SizedBox(height: 80),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        onPressed: () {
                          if (AppData().isLanguage) {
                            Get.to(() => const SocialLogin());
                          }
                        },
                        style: flatButtonStyle,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AppData().isLanguage
                                      ? AppData().language!.signIn.toUpperCase()
                                      : "SIGN IN",
                                  textAlign: TextAlign.center,
                                  style: openSansBold.copyWith(
                                    color: textBtnColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      clipBehavior: Clip.none,
                      style: TextButton.styleFrom(
                        elevation: 0,
                        shadowColor: null,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 45),
                        maximumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 45),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (AppData().isLanguage) {
                          Get.to(() => SignUpScreen());
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                AppData().isLanguage
                                    ? AppData().language!.signUp.toUpperCase()
                                    : "SIGN UP",
                                textAlign: TextAlign.center,
                                style: openSansBold.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                          ]),
                    ),
                    const SizedBox(height: 15),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getLanguage() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_language', {
      "language":
          AppData().isLanguage ? AppData().language!.currentLanguage : "english"
    });
    if (response['status'] == 'success') {
      print(response);
      var jsonData = response['data'];
      Language language = Language.fromJson(jsonData);
      AppData().language = language;
      print(AppData().language!.toJson());
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      print(response['message']);
      //showCustomSnackBar(response['message']);

    }
  }
}
=======
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/language_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_up_screen.dart';
import 'package:knaw_news/view/screens/auth/social_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: Container(
                  child: Column(children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      Images.logo_name_vertical,
                      width: 150,
                    ),
                    const SizedBox(height: 80),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        onPressed: () {
                          if (AppData().isLanguage) {
                            Get.to(() => const SocialLogin());
                          }
                        },
                        style: flatButtonStyle,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AppData().isLanguage
                                      ? AppData().language!.signIn.toUpperCase()
                                      : "SIGN IN",
                                  textAlign: TextAlign.center,
                                  style: openSansBold.copyWith(
                                    color: textBtnColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      clipBehavior: Clip.none,
                      style: TextButton.styleFrom(
                        elevation: 0,
                        shadowColor: null,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 45),
                        maximumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 45),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (AppData().isLanguage) {
                          Get.to(() => SignUpScreen());
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                AppData().isLanguage
                                    ? AppData().language!.signUp.toUpperCase()
                                    : "SIGN UP",
                                textAlign: TextAlign.center,
                                style: openSansBold.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                          ]),
                    ),
                    const SizedBox(height: 15),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getLanguage() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_language', {
      "language":
          AppData().isLanguage ? AppData().language!.currentLanguage : "english"
    });
    if (response['status'] == 'success') {
      print(response);
      var jsonData = response['data'];
      Language language = Language.fromJson(jsonData);
      AppData().language = language;
      print(AppData().language!.toJson());
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      print(response['message']);
      //showCustomSnackBar(response['message']);

    }
  }
}
>>>>>>> 703bfd9dc938819c072141626024714eff58f344
