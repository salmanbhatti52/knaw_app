import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/api/signin_with_google.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_in_screen.dart';
import 'package:knaw_news/view/screens/dashboard/dashboard_screen.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  String isSocialLogin = '0';
  Profile profile = Profile();
  var status;
  String? oneSignalId;
  @override
  void initState() {
    super.initState();
    getOneSignalId();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      socialCheck();
    });
  }

  Future<void> getOneSignalId() async {
    status = await OneSignal.shared.getDeviceState();
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
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                child: Column(children: [
                  Image.asset(
                    Images.logo_name_vertical,
                    width: 150,
                  ),
                  //const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  //Text('Knaw News', style: openSansExtraBold.copyWith(fontSize: 25)),
                  const SizedBox(height: 20),
                  SvgPicture.asset(
                    Images.mobile,
                    width: 180,
                  ),
                  const SizedBox(height: 40),

                  //SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextButton(
                      onPressed: () => Get.to(() => const SignInScreen()),
                      style: flatButtonStyle,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                AppData()
                                    .language!
                                    .signInWithEmail
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: openSansBold.copyWith(
                                  color: textBtnColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (isSocialLogin == '1')
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        //I changed this after removing facebook authentication
                        onPressed: () {
                          signinWithFacebook();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Images.facebook,
                                width: 40,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                  AppData()
                                      .language!
                                      .signInWithFacebook
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: openSansBold.copyWith(
                                    color: textBtnColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )),
                            ]),
                      ),
                    ),
                  const SizedBox(height: 15),
                  if (isSocialLogin == '1')
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        onPressed: () => signinWithGoogle(),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Images.google,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                  AppData()
                                      .language!
                                      .signInWithGoogle
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: openSansBold.copyWith(
                                    color: textBtnColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )),
                            ]),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signinWithFacebook() async {
    // print('in Facebooooook login');
    LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email', 'user_friends'],
    );

    print('@@@@@${loginResult.status}');
    print('@@@@@@${LoginStatus.success}');

    Get.to(() => DashboardScreen(pageIndex: 0));
    // if (result.status == LoginStatus.success) {
    //   print("Result LoginStatus.success");

    //   // you are logged
    //   final AccessToken accessToken = result.accessToken!;
    //   print(accessToken);
    //   final userData = await FacebookAuth.instance.getUserData(
    //     fields: "name,email,id",
    //   );
    //   // print("User Data For Facebook");
    //   // print(userData.toString());
    //   // print("User Data For Facebook");
    //   // oneSignalId=status?.userId;
    //   // print("oneSignalId");
    //   // print(oneSignalId);
    //   openLoadingDialog(context, "Loading");
    //   var response;
    //   response = await DioService.post('signup_with_social', {
    //     "userName": userData['name'],
    //     "userEmail": userData['email'],
    //     "accountType": "facebook",
    //     "userType": "1",
    //     "facebookId": userData['id'],
    //     "oneSignalId": oneSignalId ?? '25d5802c-6c85-11ec-88e7-76b6e1333fa0'
    //   });
    //   print(response);
    //   if (response['status'] == 'success / Signed in with Facebook') {
    //     print("Facebook Login Succes");
    //     var jsonData = response['data'];
    //     UserDetail userDetail = UserDetail.fromJson(jsonData);
    //     print("Facebook Login Succes");
    //     AppData().userdetail = userDetail;
    //     print(AppData().userdetail!.toJson());
    //     print("After App Data Facebook Login Succes");
    //     Navigator.pop(context);
    //     //showCustomSnackBar(response['status'],isError: false);
    //     Get.to(() => DashboardScreen(pageIndex: 0));
    //   } else {
    //     Navigator.pop(context);
    //     print("Api Response Data Error");
    //     print(response);
    //     print("Api Response Data Error");
    //     //showCustomSnackBar(response['status']);

    //   }
    //   print(userData.toString());
    // } else {
    //   print("Facebook Login Error");
    //   print("Face book Login Result ${result.status}");
    //   print("Face book Login Message ${result.message}");
    //   print("Facebook Login AccessToken${result.accessToken}");
    //   //showCustomSnackBar(result.message.toString());
    // }
  }

  Future<void> signinWithGoogle() async {
    print("getuserdetail");
    final user = await GoogleSignInApi.login();
    if (user != null) {
      print(user.toString());
      openLoadingDialog(context, "Loading");
      oneSignalId = status?.userId;
      print("oneSignalId");
      print(oneSignalId);
      var response;
      response = await DioService.post('signup_with_social', {
        "userName": user.displayName,
        "userEmail": user.email,
        "accountType": "google",
        "userType": "1",
        "googleAccessToken": user.id,
        "oneSignalId": oneSignalId ?? '25d5802c-6c85-11ec-88e7-76b6e1333fa0'
      });
      print(response);
      if (response['status'] == 'success / Signed in with Google') {
        var jsonData = response['data'];
        UserDetail userDetail = UserDetail.fromJson(jsonData);
        AppData().userdetail = userDetail;
        print(AppData().userdetail!.toJson());
        Navigator.pop(context);
        //showCustomSnackBar(response['status'],isError: false);
        Get.to(() => DashboardScreen(pageIndex: 0));
      } else {
        Navigator.pop(context);
        print(response['status']);
        //showCustomSnackBar(response['status']);
      }
    } else {
      //showCustomSnackBar("User has canceled Login with Google");
    }

    //Get.to(() => SignInScreen());
  }

  void socialCheck() async {
    openLoadingDialog(context, 'Loading');
    var response;
    response = await DioService.get('check_social_login');
    if (response['status'] == 'success') {
      isSocialLogin = response['message'];
      Navigator.of(context).pop();
      setState(() {});
      print('inside social check');
      print(response['message']);
    } else {
      Navigator.of(context).pop();
      print(response['message']);
    }
  }
}
