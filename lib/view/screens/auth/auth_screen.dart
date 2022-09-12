import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/language_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/auth/sign_up_screen.dart';
import 'package:knaw_news/view/screens/auth/social_login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getLanguage();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Center(
              child: Container(

                child: Column(children: [

                  SizedBox(height: 20),
                  Image.asset(Images.logo_with_name, width: 150,),
                  SizedBox(height: 80),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),


                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                  Container(
                    height: 45,
                      width: MediaQuery.of(context).size.width*0.75,
                      child: TextButton(
                        onPressed: () {
                          if(AppData().isLanguage) {
                            Get.to(() => SocialLogin());
                          }
                        },
                        style: flatButtonStyle,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(AppData().isLanguage?AppData().language!.signIn.toUpperCase():"SIGN IN", textAlign: TextAlign.center, style: openSansBold.copyWith(
                            color: textBtnColor,
                            fontSize: Dimensions.fontSizeDefault,
                          )),
                        ]),
                      ),
                  ),
                  SizedBox(height: 25),
                  TextButton(
                    clipBehavior: Clip.none,
                    style: TextButton.styleFrom(
                      elevation: 0,
                      shadowColor: null,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width*0.75, 45),
                      maximumSize: Size(MediaQuery.of(context).size.width*0.75, 45),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      if(AppData().isLanguage) {
                        Get.to(() => SignUpScreen());
                      }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(AppData().isLanguage?AppData().language!.signUp.toUpperCase():"SIGN UP", textAlign: TextAlign.center, style: openSansBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeDefault,
                      )),
                    ]),
                  ),
                  SizedBox(height: 15),
                ]),
              ),
            ),
          ),
        ),
      ),),
    );
  }
  void getLanguage() async {
      openLoadingDialog(context, "Loading");
      var response;
      response = await DioService.post('get_language', {
        "language":AppData().isLanguage?AppData().language!.currentLanguage:"english"
      });
      if(response['status']=='success'){
        print(response);
        var jsonData= response['data'];
        Language language   =  Language.fromJson(jsonData);
        AppData().language=language;
        print(AppData().language!.toJson());
        Navigator.pop(context);
      }
      else{
        Navigator.pop(context);
        print(response['message']);
        //showCustomSnackBar(response['message']);

      }


  }
}
