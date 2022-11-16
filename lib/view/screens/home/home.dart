<<<<<<< HEAD
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/widget/full_transition.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/post/widget/category_item.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

import '../../../model/emojis_model.dart';


class HomeScreen extends StatefulWidget  {

  HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Widget> tabs = [];
  List<Widget> tabsItems = [];
  List<GetEmojis>? emojies;
  ScrollController scrollController=ScrollController();
  TabController? _tabController;
  List <Placemark>? plackmark;
  String address="";
  String country="";
  Position position=Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  int selected=0;
  String category="0";
  String offset="0";
  bool isLoading=true;
  List<PostDetail>? postDetail;
  int totalPost=-1;
  bool dataLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getEmojis();

    _tabController = TabController(length: 16, initialIndex: 0, vsync: this,);
    // _tabController!.addListener(_handleTabSelection);
    // scrollController.addListener(_handleScroll);

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   loadPosts();
    //  });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: CustomAppBar(leading: Images.menu,
      title: Images.knaw_app_hori,
        isSuffix: false,),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: BottomAppBar(
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
                ]),
          ),
        ),
      ),
      body: dataLoaded == false ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : SafeArea(child: Center(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 5),
                child: DefaultTabController(
                    length: emojies!.length,
                    child: SizedBox(
                      height: 60,
                      //width: 200,
                      child: TabBar(
                        controller: _tabController,
                        padding: EdgeInsets.zero,
                        indicatorColor: Colors.amber,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        isScrollable: true,
                        unselectedLabelStyle: openSansBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: openSansBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: tabs
                      ),
                    )
                ),
              ),
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width*0.93,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: tabsItems,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),),
    );
  }




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {

      position=await _determinePosition();
      await convertToAddress(position.latitude, position.longitude, AppConstants.apiKey);
    if(AppData().userdetail!.address.isEmpty){
      AppData().userdetail!.address=address;
      AppData().userdetail!.country=country;
      AppData().userdetail!.latitude=position.latitude;
      AppData().userdetail!.longitude=position.longitude;

    }
    else{
      AppData().userdetail!.address=address;
      AppData().userdetail!.country=country;
      AppData().userdetail!.latitude=position.latitude;
      AppData().userdetail!.longitude=position.longitude;
    }
    AppData().update();

  }
  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

    var response = await dio.get(apiurl); //send get request to API URL

    print(response.data);

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0){ //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          address = firstresult["formatted_address"];
          List<String> list=address.split(',');
          print("this is country name");
          print(list.last);
          country = list.last.trim();
          print(firstresult["geometry"]["location"]);


          //showCustomSnackBar(address,isError: false);//get the address

          //you can use the JSON data to get address in your own format

          setState(() {
            //refresh UI
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }

  void getEmojis() async {
    var response;
    response = await DioService.get('get_all_emoji');
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      emojies= jsonData.map<GetEmojis>((e) => GetEmojis.fromJson(e)).toList();
      for(int i= 0; i<emojies!.length; i++){
        // print(emojies![i].path);
        tabs.add(
          CategoryItem(
               isSelected: selected ==emojies![i].id?true:false,
              icon: 'assets/emojis/${emojies![i].path}',
              onTap: (){
                // print("seleteeee ${selected}");
                // print("emojies![i].id ${emojies![i].id}");
                 _tabController!.index = emojies![i].id!;
                setState(() {});
              }),
        );

        tabsItems.add(
            FullTransition(cateID: emojies![i].id!)
        );
      }

      dataLoaded = true;
      setState(() {

      });


    }
    else{
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }

}
=======
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/app_constants.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:knaw_news/view/screens/home/widget/full_transition.dart';
import 'package:knaw_news/view/screens/menu/app_bar.dart';
import 'package:knaw_news/view/screens/menu/drawer.dart';
import 'package:knaw_news/view/screens/post/create_post_screen.dart';
import 'package:knaw_news/view/screens/post/widget/category_item.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';
import 'package:knaw_news/view/screens/search/search_screen.dart';

import '../../../model/emojis_model.dart';


class HomeScreen extends StatefulWidget  {

  HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Widget> tabs = [];
  List<Widget> tabsItems = [];
  List<GetEmojis>? emojies;
  ScrollController scrollController=ScrollController();
  TabController? _tabController;
  List <Placemark>? plackmark;
  String address="";
  String country="";
  Position position=Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  int selected=0;
  String category="0";
  String offset="0";
  bool isLoading=true;
  List<PostDetail>? postDetail;
  int totalPost=-1;
  bool dataLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getEmojis();

    _tabController = TabController(length: 16, initialIndex: 0, vsync: this,);
    // _tabController!.addListener(_handleTabSelection);
    // scrollController.addListener(_handleScroll);

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   loadPosts();
    //  });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  MyDrawer(),
      appBar: CustomAppBar(leading: Images.menu,
      title: Images.knaw_app_hori,
        isSuffix: false,),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: BottomAppBar(
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
                ]),
          ),
        ),
      ),
      body: dataLoaded == false ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : SafeArea(child: Center(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 5),
                child: DefaultTabController(
                    length: emojies!.length,
                    child: SizedBox(
                      height: 60,
                      //width: 200,
                      child: TabBar(
                        controller: _tabController,
                        padding: EdgeInsets.zero,
                        indicatorColor: Colors.amber,
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        isScrollable: true,
                        unselectedLabelStyle: openSansBold.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                        labelStyle: openSansBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        tabs: tabs
                      ),
                    )
                ),
              ),
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width*0.93,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: tabsItems,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),),
    );
  }




  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation() async {

      position=await _determinePosition();
      await convertToAddress(position.latitude, position.longitude, AppConstants.apiKey);
    if(AppData().userdetail!.address.isEmpty){
      AppData().userdetail!.address=address;
      AppData().userdetail!.country=country;
      AppData().userdetail!.latitude=position.latitude;
      AppData().userdetail!.longitude=position.longitude;

    }
    else{
      AppData().userdetail!.address=address;
      AppData().userdetail!.country=country;
      AppData().userdetail!.latitude=position.latitude;
      AppData().userdetail!.longitude=position.longitude;
    }
    AppData().update();

  }
  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";

    var response = await dio.get(apiurl); //send get request to API URL

    print(response.data);

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0){ //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          address = firstresult["formatted_address"];
          List<String> list=address.split(',');
          print("this is country name");
          print(list.last);
          country = list.last.trim();
          print(firstresult["geometry"]["location"]);


          //showCustomSnackBar(address,isError: false);//get the address

          //you can use the JSON data to get address in your own format

          setState(() {
            //refresh UI
          });
        }
      }else{
        print(data["error_message"]);
      }
    }else{
      print("error while fetching geoconding data");
    }
  }

  void getEmojis() async {
    var response;
    response = await DioService.get('get_all_emoji');
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      emojies= jsonData.map<GetEmojis>((e) => GetEmojis.fromJson(e)).toList();
      for(int i= 0; i<emojies!.length; i++){
        // print(emojies![i].path);
        tabs.add(
          CategoryItem(
               isSelected: selected ==emojies![i].id?true:false,
              icon: 'assets/emojis/${emojies![i].path}',
              onTap: (){
                // print("seleteeee ${selected}");
                // print("emojies![i].id ${emojies![i].id}");
                 _tabController!.index = emojies![i].id!;
                setState(() {});
              }),
        );

        tabsItems.add(
            FullTransition(cateID: emojies![i].id!)
        );
      }

      dataLoaded = true;
      setState(() {

      });


    }
    else{
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }

}
>>>>>>> 703bfd9dc938819c072141626024714eff58f344
