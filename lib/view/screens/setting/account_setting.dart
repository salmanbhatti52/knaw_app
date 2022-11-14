import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/menu/appbar_with_back.dart';
import 'package:knaw_news/view/screens/setting/setting.dart';
import 'package:progress_indicators/progress_indicators.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  double minPrice = 0;
  double maxPrice = 100;
  double _lowerValue = 0;
  double _upperValue = 100;
  bool isActive=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lowerValue=AppData().userdetail!.newsRadius!.toDouble();
    isActive=AppData().userdetail!.notificationStatus=="False"?false:true;
    print("  -----------------------active  -------------");
    print(isActive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(title: AppData().language!.accountSetting,isTitle: true,isSuffix: false,),
      //backgroundColor:Get.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(child: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.075),
                  //   alignment: Alignment.centerLeft,
                  //   child: Text("News Radius    ${_lowerValue.floor().toString()+"km"}",style: openSansRegular.copyWith(color: textColor),),
                  // ),
                  // SizedBox(height: 30,),
                  // Container(
                  //   width: MediaQuery.of(context).size.width*0.88,
                  //   child: SliderTheme(
                  //     data: SliderThemeData(
                  //       activeTrackColor: Colors.amber,
                  //       inactiveTrackColor: Theme.of(context).disabledColor,
                  //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  //       overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
                  //       valueIndicatorColor: Colors.transparent,
                  //       showValueIndicator: ShowValueIndicator.always,
                  //       valueIndicatorTextStyle: openSansSemiBold.copyWith(color:Colors.black),
                  //     ),
                  //     child: Slider(
                  //       autofocus: true,
                  //       activeColor: Colors.amber,
                  //       value: _lowerValue,
                  //       divisions: 60,
                  //       min: 0,
                  //       max: 60,
                  //       label: _lowerValue.floor().toString()+"km",
                  //
                  //       onChanged: (v){
                  //         setState(() {
                  //           _lowerValue=v;
                  //         });
                  //
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                  //   child: Container(
                  //     color: Theme.of(context).disabledColor.withOpacity(0.5),
                  //     width: MediaQuery.of(context).size.width*0.9,
                  //     height: 1,
                  //   ),
                  // ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      title: Text(AppData().language!.notifications,style: openSansRegular.copyWith(color: textColor,),),
                      trailing: Container(
                        height: 25,
                        width: 45,
                        child: FlutterSwitch(
                          height: 25.0,
                          width: 38.0,
                          padding: 2.0,
                          inactiveToggleColor: Colors.black,
                          activeToggleColor: Theme.of(context).primaryColor,
                          toggleSize: 25.0,
                          borderRadius: 15.0,
                          value: isActive,
                          inactiveColor: Theme.of(context).disabledColor.withOpacity(0.5),
                          activeColor: Colors.black,
                          onToggle: (v) {
                            setState(() {
                              isActive=v;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: TextButton(
                      onPressed: () => updateSetting(),
                      style: flatButtonStyle,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(AppData().language!.update, textAlign: TextAlign.center, style: openSansBold.copyWith(
                          color: textBtnColor,
                          fontSize: Dimensions.fontSizeDefault,
                        )),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),),
    );
  }
  Future<void> updateSetting() async {

    openLoadingDialog(context, "Updating");
    var response;
    response = await DioService.post('update_profile_settings', {
      "userId":AppData().userdetail!.usersId,
      "notificationStatus":isActive?"True":"False"
    });
    //"newsRadius":_lowerValue.floor(),
    if(response['status']=='success'){
      AppData().userdetail!.newsRadius= _lowerValue.floor();
      AppData().userdetail!.notificationStatus= isActive?"True":"False";
      AppData().update();
      print( AppData().userdetail!.newsRadius);

      print(AppData().userdetail!.toJson());
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
      Get.to(() => SettingScreen());
    }
    else{
      Navigator.pop(context);
      print(response['status']);
      //showCustomSnackBar(response['message']);
    }
  }
}

