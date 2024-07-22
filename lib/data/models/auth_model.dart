import 'package:wechat_clone/data/vos/user_vo.dart';

abstract class AuthenticationModel {
  Future<void> login(String email, String password);

  Future<void> register(UserVO newUser);

  bool isLoggedIn();

  UserVO getLoggedInUser();

  Future<void> logOut();

  Future<String> getOtp();


}
