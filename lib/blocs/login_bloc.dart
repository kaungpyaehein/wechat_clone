import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  String phone = "";
  bool isDisposed = false;

  /// Model
  final AuthModel _model = AuthModelImpl();

  Future onTapLogin() {
    _showLoading();
    if (password.isNotEmpty && email.isNotEmpty) {
      return _model.login(email, password).whenComplete(() => _hideLoading());
    } else {
      _hideLoading();
      return Future.error("Please check email & password!");
    }
  }

  void onEmailChanged(String email) {
    this.email = email;
    _notifySafely();
  }

  void onPasswordChanged(String password) {
    this.password = password;
    _notifySafely();
  }

  void onChangePhone(String phone) {
    this.phone = phone;
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
