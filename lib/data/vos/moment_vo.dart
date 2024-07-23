import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';

part 'moment_vo.g.dart';

@JsonSerializable()
class MomentVO {
  @JsonKey(name: "momentId")
  String? momentId;

  @JsonKey(name: "text")
  String? text;

  @JsonKey(name: "photoOneUrl")
  String? photoOneUrl;

  @JsonKey(name: "photoTwoUrl")
  String? photoTwoUrl;

  @JsonKey(name: "userId")
  String? userId;

  @JsonKey(name: "userName")
  String? userName;

  @JsonKey(name: "userProfile")
  String? userProfile;

  @JsonKey(name: "likes")
  List<String>? likes;

  @JsonKey(name: "comments")
  List<CommentVO>? comments;

  factory MomentVO.fromJson(Map<String, dynamic> json) =>
      _$MomentVOFromJson(json);

  Map<String, dynamic> toJson() => _$MomentVOToJson(this);

  MomentVO(this.momentId, this.text, this.photoOneUrl, this.photoTwoUrl,
      this.userId, this.userName, this.userProfile, this.likes, this.comments);
  MomentVO copyWith({
    String? momentId,
    String? text,
    String? photoOneUrl,
    String? photoTwoUrl,
    String? userId,
    String? userName,
    String? userProfile,
    List<String>? likes,
    List<CommentVO>? comments,
  }) {
    return MomentVO(
      momentId ?? this.momentId,
      text ?? this.text,
      photoOneUrl ?? this.photoOneUrl,
      photoTwoUrl ?? this.photoTwoUrl,
      userId ?? this.userId,
      userName ?? this.userName,
      userProfile ?? this.userProfile,
      likes ?? this.likes,
      comments ?? this.comments,
    );
  }
}
