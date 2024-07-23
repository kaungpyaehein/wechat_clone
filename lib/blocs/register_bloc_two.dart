import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/strings.dart';

class RegisterBlocTwo extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String password = "";
  String phone = "";
  String name = "";
  String dob = "";
  String gender = kGenderMale;
  String day = "";
  String month = "";
  String year = "";
  bool isTnCChecked = false;

  bool isDisposed = false;

  final AuthenticationModel authModel = AuthModelImpl();

  RegisterBlocTwo(String phoneNumber) {
    phone = phoneNumber;
  }

  void onChangeName(String text) {
    name = text;
    _notifySafely();
  }

  void onChangeEmail(String text) {
    email = text;
    _notifySafely();
  }

  void onChangePassword(String text) {
    password = text;
    _notifySafely();
  }

  void onChangeDay(String text) {
    day = text;
    _notifySafely();
  }

  void onChangeMonth(String text) {
    month = text;
    _notifySafely();
  }

  void onChangeYear(String text) {
    year = text;
    _notifySafely();
  }

  void onChangeGender(String text) {
    gender = text;
    _notifySafely();
  }

  void onClickTnC(bool value) {
    isTnCChecked = value;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future onTapSignUp() {
    _showLoading();
    final UserVO userVO = UserVO(
        contacts: [
        ],
        name: name,
        phone: phone,
        password: password,
        gender: gender,
        email: email,
        profileImage: "",
        dob: "$day/$month/$year");
    return authModel.register(userVO).whenComplete(
          () => _hideLoading(),
        );
  }

  void _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
