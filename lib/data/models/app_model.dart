import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';

abstract class AppModel {
  Future<void> createNewMoment(MomentVO momentVO);

  Future<String> uploadPhotoToFirebase(
    File? file,
  );

  Stream<List<MomentVO>> getMomentsFromNetwork();

  Future<void> onAddComment(CommentVO commentVO, String momentId);

  Future<void> onTapLike(String momentId, String userId);

  Future addNewFriend(String newFriendId);

  Future<UserVO?> getUserDataFromFirestore();

  UserVO? getUserDataFromDatabase();
  void  syncUserDataWithLocal(UserVO userVO);
}
