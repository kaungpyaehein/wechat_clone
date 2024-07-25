import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';

class MomentFeedsBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;

  bool isDisposed = false;

  List<MomentVO> moments = [];

  String? commentText;
  final AppModel _appModel = AppModelImpl();
  final AuthModel _authModelImpl = AuthModelImpl();
  StreamSubscription? _momentsSubscription;
  UserVO? currentUser;

  MomentFeedsBloc() {
    currentUser = _authModelImpl.getUserDataFromDatabase();
    _momentsSubscription = _appModel.getMomentsFromNetwork().listen((moments) {
      this.moments = moments;
      _notifySafely();
    });
  }

  Future<void> onAddNewComment(String momentId) {
    _showLoading();
    final CommentVO commentVO = CommentVO(
      DateTime.now().millisecondsSinceEpoch.toString(),
      commentText,
      currentUser?.id ?? "",
      currentUser?.name ?? "",
      currentUser?.profileImage ?? "",
    );
    return _appModel
        .onAddComment(commentVO, momentId)
        .whenComplete(() => _hideLoading());
  }

  void onChangeCommentText(String text) {
    commentText = text;
    _notifySafely();
  }

  void onTapLike(String momentId) {
    _appModel.onTapLike(momentId, currentUser?.id ?? "");
  }

  bool isLiked(List<String> likes) {
    return likes.contains(currentUser?.id ?? "");
  }

  void _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _momentsSubscription!.cancel();
    isDisposed = true;
  }
}
