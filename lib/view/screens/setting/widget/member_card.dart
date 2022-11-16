import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/mute_model.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_image.dart';

class MuteMemberCard extends StatelessWidget {
  MutedMemberDetail? mutedMemberDetail;
  void Function()? onTapSuffix;
  MuteMemberCard({Key? key, this.mutedMemberDetail,this.onTapSuffix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        child: ListTile(
          leading: Stack(
            children: [
              ClipOval(
                child: mutedMemberDetail!.mutedMemberProfilePicture == null || mutedMemberDetail!.mutedMemberProfilePicture == "" ?CustomImage(
                  image: Images.placeholder,
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                ):Image.network(
                  mutedMemberDetail!.mutedMemberProfilePicture??'',
                  width: 45,height: 45,fit: BoxFit.cover,
                ),
              ),
              mutedMemberDetail!.userVerified!?Positioned(
                bottom: 0, right: 0,
                child: SvgPicture.asset(Images.badge,height: 15,width: 15,),
              ):SizedBox(),
            ],
          ),
          title: Text(mutedMemberDetail!.mutedMemberUserName??'',style: openSansBold.copyWith(color: Colors.black,),),
          trailing: Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.red
            ),
            child: GestureDetector(child: Center(child: Text(AppData().language!.unmute,style: openSansSemiBold.copyWith(color: Colors.white),textAlign: TextAlign.center,)),onTap: onTapSuffix,),
          ),
        ),
      ),
    );
  }

}
