import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat_clone/persistence/hive_constants.dart';

part 'user_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: kHiveTypeUserVO, adapterName: kAdapterNameUserVO)
class UserVO {
  @JsonKey(name: "id")
  @HiveField(0)
  String? id;

  @JsonKey(name: "name")
  @HiveField(1)
  String? name;

  @JsonKey(name: "email")
  @HiveField(2)
  String? email;

  @JsonKey(name: "password")
  @HiveField(3)
  String? password;

  @JsonKey(name: "dob")
  @HiveField(4)
  String? dob;

  @JsonKey(name: "phone")
  @HiveField(5)
  String? phone;

  @JsonKey(name: "gender")
  @HiveField(6)
  String? gender;

  @JsonKey(name: "profile_image")
  @HiveField(7)
  String? profileImage;

  @JsonKey(name: "contacts")
  @HiveField(8)
  List<UserVO>? contacts;

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);

  UserVO({
    this.id,
    this.name,
    this.email,
    this.password,
    this.dob,
    this.phone,
    this.gender,
    this.profileImage,
    this.contacts = const [],
  });

  UserVO copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? dob,
    String? phone,
    String? gender,
    String? profileImage,
    List<UserVO>? contacts,
  }) {
    return UserVO(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      contacts: contacts ?? this.contacts,
    );
  }
}
