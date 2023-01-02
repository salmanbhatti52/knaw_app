import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';
import 'package:knaw_news/view/screens/profile/follow_profile.dart';
import 'package:knaw_news/view/screens/profile/profile_screen.dart';

class UserInfo extends StatelessWidget {
  PostDetail? postDetail;
  UserInfo({this.postDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.005),
      child: GestureDetector(
        onTap: () => Get.to(() => AppData().userdetail!.usersId==postDetail!.usersId?ProfileScreen():FollowProfile(userId: postDetail!.usersId,)),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                        shape: BoxShape.circle
                    ),

                    child:
                    ClipOval(
                      child: postDetail!.postUserProfilePicture == null || postDetail!.postUserProfilePicture == "" ?CustomImage(
                        image: Images.placeholder,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      ):Image.network(
                        postDetail!.postUserProfilePicture??'',
                        width: 35,height: 35,fit: BoxFit.cover,
                      ),
                    ),

                  ),
                  postDetail!.userVerified?Positioned(
                    bottom: 3, right: 3,
                    child: SvgPicture.asset(Images.badge,height: 15,width: 15,),
                  ):SizedBox(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all( 0.0),
                  //       child: SvgPicture.asset(Images.user,width:12,height:12,color: Colors.grey,),
                  //     ),
                  //     SizedBox(width: 5,),
                  //   ],
                  // ),
                  Text(postDetail!.postUserName??'',style: openSansBold.copyWith(fontSize:Dimensions.fontSizeSmall,color:Colors.black),),

                  Row(
                    children: [
                      SvgPicture.asset(Images.clock,width:12,height:12,color: Colors.grey,),
                      SizedBox(width: 5,),
                      Text(postDetail!.timeAgo??'',style: openSansRegular.copyWith(fontSize:Dimensions.fontSizeSmall,color:Colors.black),),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
