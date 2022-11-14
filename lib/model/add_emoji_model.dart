import 'package:json_annotation/json_annotation.dart';
part 'add_emoji_model.g.dart';
@JsonSerializable(includeIfNull: false)


class AddEmojis{

  String? usersId;
  String? newsPostId;
  String? categoryId;

  AddEmojis({this.newsPostId,this.usersId,this.categoryId});

  Map<String, dynamic> toJson() => _$AddEmojisToJson(this);
  factory AddEmojis.fromJson(json) => _$AddEmojisFromJson(json);


}