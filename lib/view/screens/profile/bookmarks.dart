import 'package:flutter/material.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/view/base/no_data_screen.dart';
import 'package:knaw_news/view/screens/home/post_for_bookmark.dart';

class Bookmarks extends StatefulWidget {
  int? userId;
  Bookmarks({Key? key, this.userId}) : super(key: key);
  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  int selected = 0;
  bool isExtend = false;
  int? extendedIndex;
  int totalPost = -1;
  List<BookmarkDetail>? bookmarkDetail;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      loadPosts();
      print(bookmarkDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Center(
        child: totalPost > 0
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookmarkDetail!.length,
                    itemBuilder: (context, index) {
                      return BookmarkPost(
                        postDetail:
                            bookmarkDetail![index].bookmarkedPostDetails,
                      );
                    }),
              )
            : Center(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : NoDataScreen()),
      ),
    );
  }

  Future<void> loadPosts() async {
    //openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post(
        'user_bookmarked_posts', {"usersId": AppData().userdetail!.usersId});
    if (response['status'] == 'success') {
      var jsonData = response['data'] as List;
      bookmarkDetail = jsonData
          .map<BookmarkDetail>((e) => BookmarkDetail.fromJson(e))
          .toList();
      //print(bookmarkDetail![1].bookmarkedPostDetails!.userVerified);
      print(bookmarkDetail![0].bookmarkedPostDetails!.toJson());
      //Get.back();
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      totalPost = bookmarkDetail!.length;
      print(totalPost.toString());
    } else {
      isLoading = false;
      //Get.back();
      if (mounted) {
        setState(() {});
      }
      //showCustomSnackBar(response['message']);
      totalPost = 0;
      print(totalPost.toString());
    }
  }

  Future<void> viewPost() async {
    //openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('view_post', {
      "usersId": bookmarkDetail![extendedIndex!].usersId,
      "newsPostId": bookmarkDetail![extendedIndex!].newsPostId
    });
    if (response['status'] == 'success') {
      bookmarkDetail![extendedIndex!].bookmarkedPostDetails!.isViewed = true;
      //Get.back();
      setState(() {});
      // showCustomSnackBar(response['data']);
    } else {
      //Get.back();
      setState(() {});
      //showCustomSnackBar(response['message'],);

    }
  }
}
