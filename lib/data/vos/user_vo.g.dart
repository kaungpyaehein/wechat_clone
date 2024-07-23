// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserVOAdapter extends TypeAdapter<UserVO> {
  @override
  final int typeId = 6;

  @override
  UserVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVO(
      id: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      dob: fields[4] as String?,
      phone: fields[5] as String?,
      gender: fields[6] as String?,
      profileImage: fields[7] as String?,
      contacts: (fields[8] as List?)?.cast<UserVO>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserVO obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.dob)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.profileImage)
      ..writeByte(8)
      ..write(obj.contacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      profileImage: json['profile_image'] as String?,
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'dob': instance.dob,
      'phone': instance.phone,
      'gender': instance.gender,
      'profile_image': instance.profileImage,
      'contacts': instance.contacts,
    };
