import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/cloud_firestore_data_agent_impl.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';

class AuthModelImpl extends AuthenticationModel {
  final WechatDataAgent wechatDataAgent = CloudFirestoreDataAgentImpl();

  @override
  UserVO getLoggedInUser() {
    // TODO: implement getLoggedInUser
    throw UnimplementedError();
  }

  @override
  bool isLoggedIn() {
    return wechatDataAgent.isLoggedIn();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> register(UserVO newUser) {
    return wechatDataAgent.registerNewUser(newUser);
  }

  @override
  Future<String> getOtp() {
    return wechatDataAgent.getOtpCode();
  }
}
