import 'package:flutter_svg/flutter_svg.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_in_screen.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  Profile profile = Profile();

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        centerTitle: true,
      ),
      //backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Center(
              child: Container(
                child: Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07),
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${AppData().language!.hey}, \n${AppData().language!.signupNow}',
                        style: openSansExtraBold.copyWith(fontSize: 25)),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(children: [
                      TextField(
                        onChanged: (value) => profile.userName = value,
                        style: openSansRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: textColor),
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocus,
                        cursorColor: Theme.of(context).primaryColor,
                        autofocus: false,
                        decoration: InputDecoration(
                          focusColor: const Color(0x00f7f7f7),
                          hoverColor: const Color(0x00f7f7f7),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
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
                        onChanged: (value) => profile.userEmail = value,
                        style: openSansRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: textColor),
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        cursorColor: Theme.of(context).primaryColor,
                        autofocus: false,
                        decoration: InputDecoration(
                          focusColor: const Color(0x00f7f7f7),
                          hoverColor: const Color(0x00f7f7f7),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            borderSide: const BorderSide(
                                style: BorderStyle.none, width: 0),
                          ),
                          isDense: true,
                          hintText: AppData().language!.email,
                          fillColor: const Color(0XBBF0F0F0),
                          hintStyle: openSansRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_DEFAULT),
                            child: SvgPicture.asset(Images.email,
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
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (value) => profile.confirmPassword = value,
                        style: openSansRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: textColor),
                        keyboardType: TextInputType.text,
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _confirmPasswordFocus,
                        autofocus: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusColor: const Color(0x00f7f7f7),
                          hoverColor: const Color(0x00f7f7f7),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            borderSide: const BorderSide(
                                style: BorderStyle.none, width: 0),
                          ),
                          isDense: true,
                          hintText: AppData().language!.confirmPassword,
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
                    ]),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextButton(
                      onPressed: () => _register(),
                      style: flatButtonStyle,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppData().language!.signup.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: openSansBold.copyWith(
                                  color: textBtnColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                          ]),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 40),
                    ),
                    onPressed: () {
                      Get.to(() => const SignInScreen());
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${AppData().language!.alreadyMember}? ",
                          style: openSansExtraBold.copyWith(
                              color: textColor,
                              fontSize: Dimensions.fontSizeDefault)),
                      TextSpan(
                          text: AppData().language!.login,
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
    );
  }

  void _register() async {
    // String _name = _nameController.text.trim();
    // String _email = _emailController.text.trim();
    // String _password = _passwordController.text.trim();
    // String _confirmPassword = _passwordController.text.trim();
    if (profile.userName.isNull) {
      //showCustomSnackBar('Enter User Name');
    } else if (profile.userEmail.isNull) {
      //showCustomSnackBar('Enter Email');
    } else if (profile.userPassword.isNull) {
      //showCustomSnackBar('Enter Password');
    } else if (profile.userPassword!.length < 6) {
      //showCustomSnackBar('Password should be 6 digit');
    } else if (profile.confirmPassword != profile.userPassword) {
      //showCustomSnackBar('Confirm password does not matched');
    } else {
      final status = await OneSignal.shared.getDeviceState();
      profile.oneSignalId = status?.userId;
      openLoadingDialog(context, "Loading");
      var response;

      // Auth auth=Auth();
      // auth.signup("https://dev.eigix.com/knawNews/api/signup", profile);
      response = await DioService.post('signup', profile.toJson());
      if (response['status'] == 'success') {
        var jsonData = response['data'];
        UserDetail userDetail = UserDetail.fromJson(jsonData);
        AppData().userdetail = userDetail;
        print(jsonData);
        print(AppData().userdetail!.toJson());
        Navigator.pop(context);
        Get.to(DashboardScreen(pageIndex: 0));
      } else {
        print("error");
        Navigator.pop(context);
        //showCustomSnackBar(response['message']);

      }
    }
  }
}
