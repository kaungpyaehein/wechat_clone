import 'dart:io';

import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/cloud_firestore_data_agent_impl.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';
import 'package:wechat_clone/persistence/daos/user_dao.dart';

class AppModelImpl extends AppModel {
  final WechatDataAgent wechatDataAgent = CloudFirestoreDataAgentImpl();
  final UserDao userDao = UserDao();

  @override
  Future<void> createNewMoment(MomentVO momentVO) {
    return wechatDataAgent.createNewMoment(momentVO);
  }

  @override
  Future<String> uploadPhotoToFirebase(File? file) {
    if (file != null) {
      return wechatDataAgent.uploadFileToFirebase(file);
    }
    return Future.error("Upload Failed");
  }

  @override
  Stream<List<MomentVO>> getMomentsFromNetwork() {
    return wechatDataAgent.getMoments();
  }

  @override
  Future<void> onAddComment(CommentVO commentVO, String momentId) {
    return wechatDataAgent.onAddComment(momentId, commentVO);
  }

  @override
  Future<void> onTapLike(String momentId, String userId) {
    return wechatDataAgent.onTapLike(momentId, userId);
  }

  @override
  Future addNewFriend(String newFriendId) {
    final UserVO? myUserInfo = getUserDataFromDatabase();
    if (myUserInfo != null) {
      return wechatDataAgent.addNewFriend(myUserInfo, newFriendId);
    }
    return Future.error("Current user is empty");
  }

  @override
  UserVO? getUserDataFromDatabase() {
    return userDao.getUserData();
  }

  @override
  Future<UserVO?> getUserDataFromFirestore() {
    return wechatDataAgent.getUserDataFromFirebase().then((userValueNew) {
      syncUserDataWithLocal(userValueNew);
      return userValueNew;
    });
  }

  @override
  void syncUserDataWithLocal(UserVO userVO) {
    userDao.saveUserData(userVO);
  }

  @override
  Stream<List<MessageVO>> getChatDetails(String receiverId) {
    return wechatDataAgent.getChatDetails(
        getUserDataFromDatabase()?.id ?? "", receiverId);
  }

  @override
  Future<void> sendMessage(MessageVO messageVO, String receiverId) {
    return wechatDataAgent.sendMessage(messageVO, receiverId);
  }

  @override
  Future<List<String>> getChatIdList() {
    return wechatDataAgent.getChatIdList(getUserDataFromDatabase()?.id ?? "");
  }

  @override
  Stream<MessageVO?> getLastMessageByChatId(
    String chatId,
  ) {
    return wechatDataAgent.getLastMessageByChatId(
        chatId, getUserDataFromDatabase()?.id ?? "");
  }

  @override
  Stream<UserVO> getUserStreamFromFirestore() {
    return wechatDataAgent
        .getUserStreamFromFirestore(getUserDataFromDatabase()?.id ?? "");
  }
}
