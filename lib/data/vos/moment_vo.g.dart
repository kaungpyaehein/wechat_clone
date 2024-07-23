// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomentVO _$MomentVOFromJson(Map<String, dynamic> json) => MomentVO(
      json['momentId'] as String?,
      json['text'] as String?,
      json['photoOneUrl'] as String?,
      json['photoTwoUrl'] as String?,
      json['userId'] as String?,
      json['userName'] as String?,
      json['userProfile'] as String?,
      (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MomentVOToJson(MomentVO instance) => <String, dynamic>{
      'momentId': instance.momentId,
      'text': instance.text,
      'photoOneUrl': instance.photoOneUrl,
      'photoTwoUrl': instance.photoTwoUrl,
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfile': instance.userProfile,
      'likes': instance.likes,
      'comments': instance.comments,
    };
