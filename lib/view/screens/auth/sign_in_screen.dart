import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_button.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_up_screen.dart';
import 'package:knaw_news/view/screens/auth/social_login.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';
import 'package:knaw_news/view/screens/forget/forget_pass_screen.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  Profile profile = Profile();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              child: Image.asset(
                Images.back,
                width: 50,
              ),
              onTap: () => Get.back(),
            ),
            title: SizedBox(
              height: 20,
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(flex: 1, child: Image.asset(r'assets/image/icon.png')),
                  const Flexible(
                      flex: 2,
                      child: Text('knaw App',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))
                              ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          //backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
          body: SafeArea(
            child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(
                    child: Container(
                      child: Column(children: [
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              '${AppData().language!.hey}, \n${AppData().language!.loginNow}',
                              style: openSansExtraBold.copyWith(fontSize: 25)),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07,
                              right: MediaQuery.of(context).size.width * 0.3),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppData().language!.enterNameAndPass,
                            style: openSansMedium.copyWith(
                              color: textColor,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(children: [
                            TextField(
                              onChanged: (value) => profile.userName = value,
                              style: openSansRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: textColor),
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              autofocus: true,
                              decoration: InputDecoration(
                                focusColor: const Color(0x00f7f7f7),
                                hoverColor: const Color(0x00f7f7f7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none, width: 0),
                                ),
                                isDense: true,
                                hintText: AppData().language!.userName,
                                fillColor: const Color(0XBBF0F0F0),
                                hintStyle: openSansRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT),
                                  child: SvgPicture.asset(Images.user_name,
                                      height: 5, width: 5, color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              onChanged: (value) => profile.userPassword = value,
                              style: openSansRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: textColor),
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              focusNode: _passwordFocus,
                              autofocus: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusColor: const Color(0x00f7f7f7),
                                hoverColor: const Color(0x00f7f7f7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.none, width: 0),
                                ),
                                isDense: true,
                                hintText: AppData().language!.password,
                                fillColor: const Color(0XBBF0F0F0),
                                hintStyle: openSansRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT),
                                  child: SvgPicture.asset(Images.lock,
                                      height: 10, width: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            Row(children: [
                              Expanded(
                                child: ListTile(
                                  minLeadingWidth: 0,
                                  hoverColor: null,
                                  focusColor: null,
                                  selectedTileColor: null,
                                  tileColor: null,
                                  leading: Checkbox(
                                    side: const BorderSide(
                                        color: Colors.red, width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.red,
                                    value: isChecked,
                                    onChanged: (val) => setState(() {
                                      isChecked = val!;
                                    }),
                                  ),
                                  title: Text(
                                    AppData().language!.rememberMe,
                                    style: openSansRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: textColor),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  horizontalTitleGap: 0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => ForgetPassScreen());
                                },
                                child: Text(
                                  '${AppData().language!.forgotPassword}?',
                                  style: openSansMedium.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Colors.red),
                                ),
                              ),
                            ]),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextButton(
                            onPressed: () => _login(),
                            style: flatButtonStyle,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppData().language!.loginNow,
                                      textAlign: TextAlign.center,
                                      style: openSansBold.copyWith(
                                        color: textBtnColor,
                                        fontSize: Dimensions.fontSizeDefault,
                                      )),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 40),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(1, 40),
                          ),
                          onPressed: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: AppData().language!.iAmNewUser + ' ',
                                style: openSansExtraBold.copyWith(
                                    color: textColor,
                                    fontSize: Dimensions.fontSizeDefault)),
                            TextSpan(
                                text: AppData().language!.signUp,
                                style: openSansExtraBold.copyWith(
                                    color: Colors.red,
                                    fontSize: Dimensions.fontSizeDefault,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 4)),
                          ])),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (profile.userName.isNull) {
      //showCustomSnackBar('Enter User Name');
    } else if (profile.userPassword.isNull) {
      //showCustomSnackBar('Enter Password');
    } else if (profile.userPassword!.length < 6) {
      //showCustomSnackBar('Password should be 6 digit');
    } else {
      final status = await OneSignal.shared.getDeviceState();
      profile.oneSignalId = status?.userId;
      openLoadingDialog(context, "Loading");
      var response;
      response = await DioService.post('login', profile.toJson());
      if (response['status'] == 'success') {
        var jsonData = response['data'];
        UserDetail userDetail = UserDetail.fromJson(jsonData);
        AppData().userdetail = userDetail;
        print(AppData().userdetail!.toJson());
        Navigator.pop(context);
        Get.to(() => DashboardScreen(pageIndex: 0));
      } else {
        Navigator.pop(context);
        showCustomSnackBar(response['message']);
      }
    }
  }

  void toggleCheckbox() {
    setState(() {
      isChecked != isChecked;
    });
  }
}
