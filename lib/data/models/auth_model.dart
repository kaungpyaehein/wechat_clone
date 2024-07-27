import 'dart:io';

import 'package:wechat_clone/data/vos/user_vo.dart';

abstract class AuthModel {
  Future<void> login(String email, String password);

  Future<void> register(UserVO newUser);

  bool isLoggedIn();

  UserVO getLoggedInUser();

  Future<void> logOut();

  Future<String> getOtp();

  Future<String> uploadProfile(
    File? file,
  );
  Future<void> updateUserInfo(UserVO userVO);

  UserVO? getUserDataFromDatabase();

  Future<void> editUserData(UserVO userVO);
}
