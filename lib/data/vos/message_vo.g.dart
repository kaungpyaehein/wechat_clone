// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageVO _$MessageVOFromJson(Map<String, dynamic> json) => MessageVO(
      json['timeStamp'] as String?,
      json['text'] as String?,
      json['imageUrl'] as String?,
      json['senderId'] as String?,
      json['senderName'] as String?,
      json['senderProfile'] as String?,
    );

Map<String, dynamic> _$MessageVOToJson(MessageVO instance) => <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderProfile': instance.senderProfile,
    };
