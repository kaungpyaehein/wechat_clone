import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "dob")
  String? dob;

  @JsonKey(name: "phone")
  String? phone;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "contacts")
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
      contacts: contacts ?? this.contacts,
    );
  }
}
