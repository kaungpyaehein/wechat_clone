import 'dart:io';

import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/cloud_firestore_data_agent_impl.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';
import 'package:wechat_clone/persistence/daos/user_dao.dart';

class AuthModelImpl extends AuthModel {
  final WechatDataAgent wechatDataAgent = CloudFirestoreDataAgentImpl();
  final UserDao userDao = UserDao();

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
    userDao.clearUserData();
    return wechatDataAgent.logOut();
  }

  @override
  Future<void> login(String email, String password) async {
    await wechatDataAgent.login(email, password);
    var userVO = await wechatDataAgent.getUserDataFromFirebase();
    userDao.saveUserData(userVO);
  }

  @override
  Future<void> register(UserVO newUser) {
    userDao.saveUserData(newUser);
    return wechatDataAgent.registerNewUser(newUser);
  }

  @override
  Future<String> getOtp() {
    return wechatDataAgent.getOtpCode();
  }

  @override
  Future<String> uploadProfile(File? file) {
    if (file != null) {
      return wechatDataAgent.uploadFileToFirebase(file);
    }
    return Future.error("Upload Failed");
  }

  @override
  Future<void> updateUserInfo(UserVO userVO) {
    /// UPDATE DATA
    userDao.saveUserData(userVO);
    return wechatDataAgent.updateUserInfo(userVO);
  }

  @override
  UserVO? getUserDataFromDatabase() {
    return userDao.getUserData();
  }


}
