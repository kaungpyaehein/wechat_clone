import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/models/moment_model.dart';
import 'package:wechat_clone/data/models/moment_model_impl.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/camera_utils.dart';

class CreateMomentBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;

  UserVO? userVO;

  List<File> images = [];

  File? imageOneFile;
  String? imageOneUrl;

  File? imageTwoFile;
  String? imageTwoUrl;

  String? momentId;

  String? text;

  bool isDisposed = false;

  /// Model
  final AuthModel _model = AuthModelImpl();
  final MomentModel _momentModel = MomentModelImpl();

  CreateMomentBloc() {
    momentId = DateTime.now().millisecondsSinceEpoch.toString();
    userVO = _model.getUserDataFromDatabase();
    _notifySafely();
  }
  Future<void> onTapCreateMoment() async {
    _showLoading();

    await uploadPhotoToFirestore();

    if (text?.isEmpty ?? true) {
      return Future.error("Error Creating Moment: Moment text cannot be empty");
    }

    final MomentVO newMoment = MomentVO(
      momentId,
      text,
      imageOneUrl,
      imageTwoUrl,
      userVO?.id ?? "",
      userVO?.name ?? "",
      userVO?.profileImage ?? "",
      [],
      [],
    );
    await _momentModel.createNewMoment(newMoment).catchError((error) {
      return Future.error("Error Creating Moment: ${error.toString()}");
    }).whenComplete(() => _hideLoading());
  }

  Future<void> uploadPhotoToFirestore() async {
    for (var image in images) {
      await _momentModel.uploadPhotoToFirebase(image).then((imageUrl) {
        if (imageOneUrl == null) {
          imageOneUrl = imageUrl;
        } else {
          imageTwoUrl = imageUrl;
        }
        _notifySafely();
        return Future.value();
      }).catchError((error) {
        return Future.error(error.toString());
      });
    }
  }

  void onChangText(text) {
    this.text = text;
    _notifySafely();
  }

  Future onChooseImages() async {
    await CameraDelegate.selectMultiplePhotos().then((images) {
      if (images?.isNotEmpty ?? false) {
        this.images = images!;
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
