import 'package:json_annotation/json_annotation.dart';
part 'inbox_notification.g.dart';


@JsonSerializable(includeIfNull: false)
class InboxNotification{
  @JsonKey(name: 'notification_id',)
  int? notificationId;
  @JsonKey(name: 'sender_users_id',)
  int? senderUserId;
  @JsonKey(name: 'receiver_users_id',)
  int? reciverUserId;
  @JsonKey(name: 'notification_type',)
  String? notificationType;
  String? message;
  String? datetime;
  @JsonKey(name: 'sender_user_name',)
  String? senderUserName;
  @JsonKey(name: 'sender_user_profile_picture',)
  String? senderProfilePicture;
  @JsonKey(name: 'user_is_verified',)
  bool? userIsVerified;
  @JsonKey(name: 'is_following_back',)
  bool? isFollowingBack;
  @JsonKey(name: 'days_ago',)
  String? daysAgo;

  InboxNotification({
    this.message,this.datetime,this.daysAgo,this.isFollowingBack,this.notificationId,this.notificationType,
    this.reciverUserId,this.senderProfilePicture,this.senderUserId,this.senderUserName,this.userIsVerified
});
  Map<String, dynamic> toJson() => _$InboxNotificationToJson(this);
  factory InboxNotification.fromJson(json) => _$InboxNotificationFromJson(json);
}