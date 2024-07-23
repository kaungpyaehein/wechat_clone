import 'package:json_annotation/json_annotation.dart';

part 'comment_vo.g.dart';

@JsonSerializable()
class CommentVO {
  @JsonKey(name: "commentId")
  String? commentId;

  @JsonKey(name: "commentText")
  String? commentText;

  @JsonKey(name: "userId")
  String? userId;

  @JsonKey(name: "userName")
  String? userName;

  @JsonKey(name: "userProfile")
  String? userProfile;
  factory CommentVO.fromJson(Map<String, dynamic> json) =>
      _$CommentVOFromJson(json);

  Map<String, dynamic> toJson() => _$CommentVOToJson(this);

  CommentVO(this.commentId, this.commentText, this.userId, this.userName,
      this.userProfile);
}
