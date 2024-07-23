// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentVO _$CommentVOFromJson(Map<String, dynamic> json) => CommentVO(
      json['commentId'] as String?,
      json['commentText'] as String?,
      json['userId'] as String?,
      json['userName'] as String?,
      json['userProfile'] as String?,
    );

Map<String, dynamic> _$CommentVOToJson(CommentVO instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'commentText': instance.commentText,
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfile': instance.userProfile,
    };
