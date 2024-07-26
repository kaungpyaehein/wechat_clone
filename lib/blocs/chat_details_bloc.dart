import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/camera_utils.dart';

class ChatDetailsBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;

  bool isDisposed = false;
  final AppModel _appModel = AppModelImpl();

  UserVO? userVo;
  UserVO? receiver;
  File? selectedImage;

  ChatDetailsBloc(UserVO receiverUser) {
    _showLoading();
    _appModel.getUserDataFromFirestore();
    userVo = _appModel.getUserDataFromDatabase();
    receiver = receiverUser;
    _hideLoading();
    _notifySafely();
  }

  Stream<List<MessageVO>> getMessagesStream() {
    return _appModel.getChatDetails(receiver?.id ?? "");
  }

  void handleSendPressed(String message) {
    final MessageVO messageVO = MessageVO(
        DateTime.now().millisecondsSinceEpoch.toString(),
        message,
        "",
        userVo?.id ?? "",
        userVo?.name ?? "",
        userVo?.profileImage ?? "");
    _appModel.sendMessage(messageVO, receiver?.id ?? "");
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

  Future sendPhotoMessage() {
    return onChooseImages().then((_) {
      _appModel.uploadPhotoToFirebase(selectedImage).then((imageUrl) {
        final MessageVO messageVO = MessageVO(
            DateTime.now().millisecondsSinceEpoch.toString(),
            "",
            imageUrl,
            userVo?.id ?? "",
            userVo?.name ?? "",
            userVo?.profileImage ?? "");
        _appModel.sendMessage(messageVO, receiver?.id ?? "");
      });
    });
  }

  Future onChooseImages() async {
    await CameraDelegate.takePhoto(isCamera: false).then((file) {
      selectedImage = file;
      _notifySafely();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
