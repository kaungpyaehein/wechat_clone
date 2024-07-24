import 'dart:io';

import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';


abstract class MomentModel {
  Future<void> createNewMoment(MomentVO momentVO);

  Future<String> uploadPhotoToFirebase(
    File? file,
  );

  Stream<List<MomentVO>> getMomentsFromNetwork();

  Future<void> onAddComment(CommentVO commentVO, String momentId);

  Future<void> onTapLike(String momentId, String userId);
}
