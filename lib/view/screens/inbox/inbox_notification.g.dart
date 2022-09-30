// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InboxNotification _$InboxNotificationFromJson(Map<String, dynamic> json) =>
    InboxNotification(
      message: json['message'] as String?,
      datetime: json['datetime'] as String?,
      daysAgo: json['days_ago'] as String?,
      isFollowingBack: json['is_following_back'] as bool?,
      notificationId: json['notification_id'] as int?,
      notificationType: json['notification_type'] as String?,
      reciverUserId: json['receiver_users_id'] as int?,
      senderProfilePicture: json['sender_user_profile_picture'] as String?,
      senderUserId: json['sender_users_id'] as int?,
      senderUserName: json['sender_user_name'] as String?,
      userIsVerified: json['user_is_verified'] as bool?,
    );

Map<String, dynamic> _$InboxNotificationToJson(InboxNotification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notification_id', instance.notificationId);
  writeNotNull('sender_users_id', instance.senderUserId);
  writeNotNull('receiver_users_id', instance.reciverUserId);
  writeNotNull('notification_type', instance.notificationType);
  writeNotNull('message', instance.message);
  writeNotNull('datetime', instance.datetime);
  writeNotNull('sender_user_name', instance.senderUserName);
  writeNotNull('sender_user_profile_picture', instance.senderProfilePicture);
  writeNotNull('user_is_verified', instance.userIsVerified);
  writeNotNull('is_following_back', instance.isFollowingBack);
  writeNotNull('days_ago', instance.daysAgo);
  return val;
}
