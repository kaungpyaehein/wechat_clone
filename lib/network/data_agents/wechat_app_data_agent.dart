import 'package:wechat_clone/data/vos/user_vo.dart';

abstract class WechatDataAgent {
  /// Auth
  Future<String> getOtpCode();
  Future registerNewUser(UserVO newUser);
  Future login(String email, String password);
  bool isLoggedIn();
  Future logOut();
}
