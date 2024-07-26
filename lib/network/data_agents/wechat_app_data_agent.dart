import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';

abstract class WechatDataAgent {
  /// Auth
  Future<String> getOtpCode();
  Future registerNewUser(UserVO newUser);
  Future login(String email, String password);
  bool isLoggedIn();
  Future logOut();
  Future<String> uploadFileToFirebase(File image);
  Future<void> updateUserInfo(UserVO userVO);
  Future<UserVO> getUserDataFromFirebase();

  //// Moments

  Stream<List<MomentVO>> getMoments();

  Future<void> createNewMoment(MomentVO momentVO);

  Future<void> onAddComment(String momentId, CommentVO commentVO);

  Future<void> onTapLike(String momentId, String userId);

  Future addNewFriend(UserVO myUserInfo, String newFriendId);

  Future<void> sendMessage(MessageVO messageVO, String receiverId);

  Stream<List<MessageVO>> getChatDetails(String senderId, String receiverId);

  Future<List<String>> getChatIdList(String currentUserId);

  Stream<MessageVO?> getLastMessageByChatId(
      String chatId, String currentUserId);
}
