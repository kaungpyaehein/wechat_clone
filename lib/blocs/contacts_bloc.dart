import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';

class ContactsBloc extends ChangeNotifier {
  List<UserVO> contacts = [];

  /// State
  bool isLoading = false;

  bool isDisposed = false;
  final AppModel _appModel = AppModelImpl();

  UserVO? userVo;

  StreamSubscription? _userSteam;
  ContactsBloc() {
    _showLoading();
    _appModel.getUserStreamFromFirestore().listen((user) {
      userVo = user;
      contacts = user.contacts ?? [];
      _notifySafely();
    });
    // userVo = _appModel.getUserDataFromDatabase();
    // contacts = userVo?.contacts ?? [];
    _hideLoading();
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
    _userSteam!.cancel();
    super.dispose();
    isDisposed = true;
  }
}
