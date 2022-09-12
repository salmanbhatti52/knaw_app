import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key? key,}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController subjectController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController messageController=TextEditingController();
  List<String> subjectType=[AppData().language!.changeUsername, AppData().language!.activeYourAccount,
    AppData().language!.deleteYourAccount,AppData().language!.keywordAlerts,
    AppData().language!.legalAndComplaints,AppData().language!.bugOrFeatureRequest,
    AppData().language!.contactModeratorTeam, AppData().language!.b2bPROtherProblem];
  String? subject;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new MyDrawer(),
      appBar: new CustomAppBar(leading: Images.menu,title: AppData().language!.contactUs,isTitle: true,isSuffix: false,),
      body: SafeArea(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical:Dimensions.PADDING_SIZE_DEFAULT),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppData().language!.subject,style: openSansBold,),
                SizedBox(height: 10,),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0XFFF0F0F0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    iconEnabledColor: Colors.black,
                    focusColor: Colors.black,
                    hint: Text("${AppData().language!.whatsYourMessageAbout}?",style: openSansRegular),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: subjectType.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: openSansRegular,),
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      print(newValue);
                      subject = newValue;
                      setState(() {});
                    },
                    value: subject,
                  ),
                ),
                SizedBox(height: 10,),
                Text(AppData().language!.yourName,style: openSansBold),
                SizedBox(height: 10,),
                TextField(
                  controller: nameController,
                  style: openSansRegular,
                  keyboardType: TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  autofocus: false,
                  decoration: InputDecoration(
                    focusColor: const Color(0XF7F7F7),
                    hoverColor: const Color(0XF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    isDense: true,
                    hintText: AppData().language!.markMood,
                    fillColor: Color(0XFFF0F0F0),
                    hintStyle: openSansRegular,
                    filled: true,

                  ),
                ),
                SizedBox(height: 10,),
                Text(AppData().language!.yourEmailAddress,style: openSansBold),
                SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  style: openSansRegular,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Theme.of(context).primaryColor,
                  autofocus: false,
                  decoration: InputDecoration(
                    focusColor: const Color(0XF7F7F7),
                    hoverColor: const Color(0XF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    isDense: true,
                    hintText: AppData().language!.gmailHint,
                    fillColor: Color(0XFFF0F0F0),
                    hintStyle: openSansRegular,
                    filled: true,

                  ),
                ),
                SizedBox(height: 10,),
                Text(AppData().language!.message,style: openSansBold),
                SizedBox(height: 10,),
                TextField(
                  controller: messageController,
                  style: openSansRegular,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Theme.of(context).primaryColor,
                  autofocus: false,
                  maxLines: 4,
                  minLines: 4,
                  decoration: InputDecoration(
                    focusColor: const Color(0XF7F7F7),
                    hoverColor: const Color(0XF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    isDense: true,
                    hintText: AppData().language!.writeTheMessage,
                    fillColor: Color(0XFFF0F0F0),
                    hintStyle: openSansRegular,
                    filled: true,

                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width*0.5,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: sendMessage,

                      style: flatButtonStyle,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(AppData().language!.sendMessage, textAlign: TextAlign.center, style: openSansBold.copyWith(
                          color: textBtnColor,
                          fontSize: Dimensions.fontSizeDefault,
                        )),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),),
    );
  }
  Future<void> sendMessage() async {
    if(subject==null){
      //showCustomSnackBar("Choose Subject");

    }
    else if(nameController.text.trim().isEmpty){
      //showCustomSnackBar("Enter Name");

    }
    else if(emailController.text.trim().isEmpty){
      //showCustomSnackBar("Enter Email");
    }
    else if(messageController.text.trim().isEmpty){
      //showCustomSnackBar("Type Message");
    }
    else{
      openLoadingDialog(context, "Sending");
      var response;

      response = await DioService.post('contact_us_web', {
        "subject": subject,
        "name": nameController.text,
        "email": emailController.text,
        "message": messageController.text
      });
      if(response['status']=='success'){
        Navigator.pop(context);
        //showCustomSnackBar(response['data'],isError: false);
        Get.to(HomeScreen());
      }
      else{
        print("2---------------error response-----------");
        Navigator.pop(context);
        //showCustomSnackBar(response['message']);

      }
      nameController.clear();
      emailController.clear();
      messageController.clear();
      setState(() {

      });
    }

  }
}

