import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/camera_utils.dart';

class UploadProfileBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  File? image;
  String? imageUrl;
  bool isDisposed = false;
  UserVO? userVO;

  /// Model
  final AuthModel _model = AuthModelImpl();

  UploadProfileBloc() {
    userVO = _model.getUserDataFromDatabase();
    _notifySafely();
  }

  Future uploadProfileImage() async {
    _showLoading();
    await _model.uploadProfile(image).then((imageUrl) {
      if (userVO != null) {
        /// update user data in both network and local
        _model.updateUserInfo(userVO!.copyWith(profileImage: imageUrl));
      } else {
        return Future.error("Error Uploading Photo");
      }
    }).whenComplete(() => _hideLoading());
  }

  Future onChooseImage() async {
    await CameraDelegate.takePhoto(isCamera: false).then((value) {
      if (value != null) {
        image = value;
        _notifySafely();
      }
    });
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
    isDisposed = true;
  }
}
