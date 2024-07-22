// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      dob: json['dob'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'dob': instance.dob,
      'phone': instance.phone,
      'gender': instance.gender,
      'contacts': instance.contacts,
    };
