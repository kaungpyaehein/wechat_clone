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

  ContactsBloc() {
    _showLoading();
    _appModel.getUserDataFromFirestore();
    userVo = _appModel.getUserDataFromDatabase();
    contacts = userVo?.contacts ?? [];
    _hideLoading();
    _notifySafely();
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
