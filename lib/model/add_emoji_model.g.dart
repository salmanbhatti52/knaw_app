// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_emoji_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddEmojis _$AddEmojisFromJson(Map<String, dynamic> json) => AddEmojis(
      newsPostId: json['newsPostId'] as String?,
      usersId: json['usersId'] as String?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$AddEmojisToJson(AddEmojis instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('usersId', instance.usersId);
  writeNotNull('newsPostId', instance.newsPostId);
  writeNotNull('categoryId', instance.categoryId);
  return val;
}
