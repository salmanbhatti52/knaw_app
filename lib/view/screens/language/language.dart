import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/language_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/home.dart';
import 'package:knaw_news/view/screens/language/widget/language_card.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> availableLanguages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getAvailableLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: CustomAppBar(
        leading: Images.menu,
        title: AppData().language!.language,
        isTitle: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: availableLanguages.length,
                  itemBuilder: (context, index) {
                    return LanguageCard(
                      title: availableLanguages[index],
                      onTapSelect: () =>
                          updateLanguage(availableLanguages[index]),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void getAvailableLanguages() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.get('language_type');
    if (response['status'] == 'success') {
      var jsonData = response['data'] as List;
      jsonData.map((e) => availableLanguages.add(e)).toList();
      print(availableLanguages);
      Navigator.pop(context);
      setState(() {});
    } else {
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }

  void updateLanguage(String language) async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_language', {"language": language});
    if (response['status'] == 'success') {
      var jsonData = response['data'];
      Language language = Language.fromJson(jsonData);
      AppData().language = language;
      print(AppData().language!.toJson());
      setState(() {});
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      print(response['message']);
      //showCustomSnackBar(response['message']);

    }
  }
}
