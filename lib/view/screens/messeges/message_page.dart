import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom-navigator.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/notification-button.dart';
import 'package:knaw_news/view/base/profile-image-picker.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/messeges/chat-model.dart';
import 'package:knaw_news/view/screens/messeges/messageDetailsPage.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<GetAllChats> chatsDetail = [];
  Timer? timer;

  final ScrollController _controller = ScrollController();

  Future getChat() async {
    try {
      var response = await DioService.post('chat', {
        "userId": AppData().userdetail!.usersId,
        "requestType": "getChatList"
      });
      var chats = response['data'] as List;
      chatsDetail =
          chats.map<GetAllChats>((e) => GetAllChats.fromJson(e)).toList();
      print(chatsDetail.toList());
      setState(() {});
    } catch (e) {
      // Navigator.of(context).pop();
      // showSuccessToast(e.toString());
    }
  }

  Future getChatList() async {
    try {
      var response = await DioService.post('chat', {
        "userId": AppData().userdetail!.usersId,
        "requestType": "getChatList"
      });
      var chats = response['data'] as List;
      chatsDetail =
          chats.map<GetAllChats>((e) => GetAllChats.fromJson(e)).toList();
      // print(chatsDetail.toList());

      Navigator.of(context).pop();
      setState(() {});
    } catch (e) {
      Navigator.of(context).pop();
      // showSuccessToast(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getChat());
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      openLoadingDialog(context, "loading...");
      getChatList();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark, statusBarColor: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
          ),
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Builder(
            builder: (context) => IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SvgPicture.asset(
                  Images.menu,
                  width: 20,
                  color: Colors.black,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        title: Text(
          'Message',
          style: openSansExtraBold.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: chatsDetail.length,
                  shrinkWrap: true,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    GetAllChats chat = chatsDetail[index];
                    return InkWell(
                      onTap: () {
                        CustomNavigator.navigateTo(
                            context,
                            MessageDetailsPage(
                              otherUserChatId: chat.user_id,
                              userName: chat.name!,
                              profilePic: chat.profile_pic!,
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: ProfileImagePicker(
                                    onImagePicked: (value) {},
                                    previousImage: chat.profile_pic ?? "",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(chat.name!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        // SizedBox(height: 10),
                                        Text(
                                          chat.message!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(chat.time!,
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12)),
                                    const SizedBox(height: 20),
                                    if (chat.badge != 0)
                                      notificationButton(chat.badge!)
                                  ],
                                )
                              ],
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
