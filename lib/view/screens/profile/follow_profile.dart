import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/signup_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom-navigator.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/report_user_dialog.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/messeges/messageDetailsPage.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/profile/show_post.dart';
import 'package:knaw_news/view/screens/profile/stats.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';
import 'package:knaw_news/view/screens/setting/setting.dart';

import '../home/widget/report_dialog.dart';

class FollowProfile extends StatefulWidget {
  int? userId;
  int? id;

  FollowProfile({Key? key,this.userId,this.id}) : super(key: key);

  @override
  _FollowProfileState createState() => _FollowProfileState();
}

class _FollowProfileState extends State<FollowProfile> with TickerProviderStateMixin {
  UserDetail userDetail =UserDetail();
  bool isreported = false;
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getProfileDetail();
    });
  }
  void showCustomDialog(context) {
    double w =MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (ctx) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.zero,
              height: 255,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Block ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Text("${userDetail.userName.toString()} ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('They will not be able to send u messages,see your posts,or find your profile.'
                    ' This doesn\'t include extended scenarios like multi-host livestreams,duets posted by others, or group chats you both participate in.'
                        ' They will not be notify that you blocked them.',
                      style: TextStyle(fontSize: 14  ),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 15),
                    Container(height: 0.5,color: Colors.grey.shade400,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: (){Navigator.pop(context);},
                            child: Text('Cancel',style: TextStyle(color: Colors.black,fontSize: 16),),
                        ),
                        Container(height: 60,width: 0.5,color: Colors.grey.shade400,),
                        TextButton(
                            onPressed: (){
                              blockUser();
                              reloadProfileDetail();
                            },
                            child: Text('Block',style: TextStyle(color: Colors.red,fontSize: 16),),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new MyDrawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.white
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
          ),
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Scaffold.of(context).openDrawer();
          },
          child: Builder(
            builder: (context) => IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(Images.menu, width: 20,color: Colors.black,),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        title: Text(AppData().language!.profile,style: openSansExtraBold.copyWith(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          //Image.asset(Images.filter, width: 20,),
          PopupMenuButton(
            offset: Offset(-30, 30),
            color: Colors.white,
            elevation: 2,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: GestureDetector(
                  onTap: (){
                    userDetail.isMuted?SizedBox():muteMember();
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                       SvgPicture.asset('assets/image/mute.svg',color: Colors.amber,height: 20,),
                        SizedBox(
                          width: 10,
                        ),
                      Text(userDetail.isMuted?'Muted':AppData().language!.mute,style: openSansSemiBold.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall+2),textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: GestureDetector(
                  onTap: (){
                  userDetail.isBlocked?SizedBox():showCustomDialog(context);
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/image/block.svg',color: Colors.amber,height: 20,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(userDetail.isBlocked?"Blocked":'Block',style: openSansSemiBold.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall+2),textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: GestureDetector(
                  onTap: (){
                    userDetail.isReported?SizedBox():Get.dialog(ReportUserDialog(onUserReport: (val){reportUser(val);},));
                  reloadProfileDetail();
                    },
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/image/report1.svg',color: Colors.amber,height: 20,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(userDetail.isReported?"Reported":"Report",style: openSansSemiBold.copyWith(color: Colors.black,fontSize: Dimensions.fontSizeSmall+2),textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                ),
              ),
            ],

          ),
          /// MUTE
          // GestureDetector(
          //   onTap: userDetail.isMuted?unMuteMember:muteMember,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 5),
          //     margin: EdgeInsets.only(top: 15,bottom: 15,right: 15),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(5),
          //         color: Colors.red
          //     ),
          //     child: Center(child: Text(userDetail.isMuted?AppData().language!.unmute:AppData().language!.mute,style: openSansSemiBold.copyWith(color: Colors.white,fontSize: Dimensions.fontSizeSmall),textAlign: TextAlign.center,)),
          //   ),
          // ),
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
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: BottomAppBar(
          //elevation: 0.0,
          //notchMargin: 2,
          //clipBehavior: Clip.antiAlias,
          //shape: CircularNotchedRectangle(),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BottomNavItem(iconData: Images.home,isSelected: false, onTap: () => Get.to(HomeScreen())),
                  BottomNavItem(iconData: Images.search, isSelected: false , onTap: () => Get.to(SearchScreen())),
                  BottomNavItem(iconData: Images.add,isSelected: false, onTap: () => Get.to(PostScreen())),
                  BottomNavItem(iconData: Images.user,isSelected: false, onTap: () => Get.to(ProfileScreen())),
                  // BottomNavItem(title:'home'.tr,iconData: Images.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                  // BottomNavItem(title:'favourite'.tr,iconData: Images.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                  // Expanded(child: SizedBox()),
                  // BottomNavItem(title:'my_order'.tr,iconData: Images.bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
                  // BottomNavItem(title:'notification'.tr,iconData: Images.notification, isSelected: _pageIndex == 4, onTap: () {
                  //   Get.toNamed(RouteHelper.getNotificationRoute());
                  // }),
                ]),
          ),
        ),
      ),
      body: Container(child: Column(
        children: [
          Container(
            //height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.amber,
                            width: 4,
                          ),
                          shape: BoxShape.circle
                      ),

                      child: Stack(
                        children: [
                          ClipOval(
                            child: userDetail.profilePicture == null || userDetail.profilePicture == "" ?CustomImage(
                              image: Images.placeholder,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ):Image.network(
                              userDetail.profilePicture??'',
                              width: 90,height: 90,fit: BoxFit.cover,
                            ),
                          ),
                          userDetail.userVerified==null?SizedBox():userDetail.userVerified?Positioned(
                            bottom: 2, right: 2,
                            child: SvgPicture.asset(Images.badge,),
                          ):SizedBox(),
                        ],
                      ),

                    ),
                    Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userDetail.userName??"Name",style: openSansExtraBold.copyWith(color:Colors.black),),

                          Text("${AppData().language!.joined} "+userDetail.joinedSince.toString(),style: openSansRegular.copyWith(color:textColor),),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: SvgPicture.asset(Images.followers,color: Colors.black,),
                              ),
                              SizedBox(width: 5,),
                              Text(AppData().language!.followers,style: openSansRegular.copyWith(color:Colors.black),),
                              SizedBox(width: 5,),
                              Text(userDetail.totalFollowers.toString(),style: openSansRegular.copyWith(color:Colors.black),),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: followUser,
                                child: Container(
                                  height: 33,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: userDetail.isFollowed?Colors.amber:Colors.black
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    //   child: SvgPicture.asset(Images.user,color: Colors.white,),
                                    // ),
                                    Text(userDetail.isFollowed?AppData().language!.unfollow:AppData().language!.follow,style: openSansRegular.copyWith(color:Colors.white),)

                                  ],),
                                ),
                              ),
                              SizedBox(width: 15,),
                              GestureDetector(
                                onTap: (){
                                  CustomNavigator.navigateTo(context, MessageDetailsPage(
                                   userName: userDetail.userName.toString(),
                                    profilePic: userDetail.profilePicture!,
                                    otherUserChatId: userDetail.usersId,
                                  ));
                                },
                                child: Container(
                                  height: 33,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.amber
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Text('Message',style: openSansRegular.copyWith(color:Colors.white),)

                                    ],),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: 10),
                    child: Text(userDetail.description??'',style: openSansRegular.copyWith(color:Colors.black),)),

              ],
            ),
          ),
          // Container(
          //
          //   child: Text("Profile",style: openSansExtraBold.copyWith(fontSize: 30),),
          // ),

          Container(
            //padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(top: 10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Container(
              height: 35,
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TabBar(
                labelPadding: EdgeInsets.all(2),
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadiusDirectional.circular(20),
                ),
                indicatorColor:Theme.of(context).primaryColor,
                indicatorWeight: 3,
                labelColor:Colors.black,
                unselectedLabelColor:Colors.black,
                unselectedLabelStyle: openSansBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                labelStyle: openSansBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                tabs: [
                  Tab(text: AppData().language!.posts),
                  Tab(text: AppData().language!.stats),
                ],
              ),
            ),
          ),

          widget.userId==AppData().userdetail!.usersId?const SizedBox():
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ShowPost(userId: widget.userId,),
                StatsScreen(userId: widget.userId,),
              ],
            ),
          ),
        ],
      ),),
    );
  }
  Future<void> getProfileDetail() async {
      var response;
      openLoadingDialog(context, "Loading");
      response = await DioService.post('get_other_profile_details', {
        "usersId" : AppData().userdetail!.usersId,
        "otherUserId" : widget.userId
      });
      if(response['status']=='success'){
        var jsonData= response['data'];
        userDetail  =  UserDetail.fromJson(jsonData);
        print(userDetail.toJson());
        Navigator.pop(context);
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => ProfileScreen());
          return;
        }
        setState(() {});
        // showCustomSnackBar(response['status'],isError: false);
      }
      else{
        Navigator.pop(context);
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => ProfileScreen());
          return;
        }
        setState(() {

        });
        //showCustomSnackBar(response['status']);
      }
    }
  Future<void> reloadProfileDetail() async {
      var response;
      response = await DioService.post('get_other_profile_details', {
        "usersId" : AppData().userdetail!.usersId,
        "otherUserId" : widget.userId
      });
      if(response['status']=='success'){
        var jsonData= response['data'];
        userDetail  =  UserDetail.fromJson(jsonData);
        print(userDetail.toJson());
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => ProfileScreen());
          return;
        }
        setState(() {});
        // showCustomSnackBar(response['status'],isError: false);
      }
      else{
        if(widget.userId==AppData().userdetail!.usersId){
          Get.to(() => ProfileScreen());
          return;
        }
        setState(() {

        });
        //showCustomSnackBar(response['status']);
      }
    }
  Future<void> followUser() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('follow_user', {
      "followingToUser" : userDetail.usersId,
      "followedByUser" : AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      Navigator.pop(context);
      userDetail.isFollowed=!userDetail.isFollowed;
      setState(() {

      });
      //showCustomSnackBar(response['data'],isError: false);
      //print(followDetail[2].toJson());
    }
    else{
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);

    }
  }
  void muteMember() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('mute_member', {
      "muteUsersId": userDetail.usersId,
      "usersId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      userDetail.isMuted=true;
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);
    }

  }
  void unMuteMember() async{
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('unmute_member', {
      "muteUsersId": userDetail.usersId,
      "usersId": AppData().userdetail!.usersId
    });
    if(response['status']=='success'){
      userDetail.isMuted=false;
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      setState(() {

      });
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);
    }
  }
  void reportUser(String reason) async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "reportedByUserId":AppData().userdetail!.usersId.toString(),
      "reportedToUserId":widget.userId.toString(),
      "reason":reason
    };
    print(data);
    response = await DioService.post('report_user', data);
    print(response);
    if(response['status']=='success'){
      showCustomSnackBar(response['message']);
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }

  void blockUser() async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "blockedByUserId":AppData().userdetail!.usersId.toString(),
      "blockedUserId":widget.userId.toString()
    };
    print(data);
    response = await DioService.post('block_user', data);
    print(response);
    if(response['status']=='success'){
       showCustomSnackBar("Blocked successfully");
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
      Navigator.pop(context);

    }
  }
  void unblockUser() async {
    openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "blockedByUserId":AppData().userdetail!.usersId.toString(),
      "blockedUserId":widget.userId.toString()
    };
    print(data);
    response = await DioService.post('unblock_user', data);
    print(response);
    if(response['status']=='success'){
      showCustomSnackBar("Blocked successfully");
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }

}

