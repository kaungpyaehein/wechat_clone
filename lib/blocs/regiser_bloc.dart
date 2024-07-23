import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';

class RegisterBlocOne extends ChangeNotifier {
  /// State
  bool isLoading = false;

  String phone = "";

  String otpFromServer = "";
  String otp = "";

  bool isDisposed = false;

  final AuthModel authModel = AuthModelImpl();

  RegisterBlocOne() {
    authModel.getOtp().then((code) {
      otpFromServer = code;
      _notifySafely();
    });
  }

  void onChangeOTP(String code) {
    otp = code;
    _notifySafely();
  }

  void onChangePhoneNumber(String phoneNumber) {
    phone = phoneNumber;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  bool checkOTP() {
    return (otpFromServer == otp) && phone.isNotEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
