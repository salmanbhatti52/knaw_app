import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

class SpecificPost extends StatefulWidget {
  int postId;
  SpecificPost({Key? key, required this.postId}) : super(key: key);

  @override
  _SpecificPostState createState() => _SpecificPostState();
}

class _SpecificPostState extends State<SpecificPost> {
  List<PostDetail> postDetail = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadSpecificPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double mediaWidth = size.width;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: CustomAppBar(
          leading: Images.menu,
          title: Images.logo_name,
          isSuffix: false,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomNavItem(
                        iconData: Images.home,
                        isSelected: false,
                        onTap: () => Get.to(HomeScreen())),
                    BottomNavItem(
                        iconData: Images.search,
                        isSelected: false,
                        onTap: () => Get.to(const SearchScreen())),
                    BottomNavItem(
                        iconData: Images.add,
                        isSelected: false,
                        onTap: () => Get.to(const PostScreen())),
                    BottomNavItem(
                        iconData: Images.user,
                        isSelected: false,
                        onTap: () => Get.to(ProfileScreen())),
                  ]),
            ),
          ),
        ),
        body: Center(
          child: Container(
            width: mediaWidth,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(child: NoDataScreen()),
              // postDetail.length>0?FullTransition(postDetail: postDetail[0])
              //       :Center(child: NoDataScreen()),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadSpecificPosts() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('specific_post',
        {"usersId": AppData().userdetail!.usersId, "postId": widget.postId});
    print(response);
    if (response['status'] == 'success') {
      var jsonData = response['data'] as List;
      postDetail = jsonData.map((e) => PostDetail.fromJson(e)).toList();
      Navigator.pop(context);
      isLoading = false;
      setState(() {});
      // showCustomSnackBar(postDetail![0].title??'');
    } else {
      Navigator.pop(context);
      setState(() {});
    }
  }
}
