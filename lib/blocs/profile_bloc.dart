import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/strings.dart';

class ProfileBloc extends ChangeNotifier {
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

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
  String monthHintText = "";
  UserVO? currentUser;

  bool isDisposed = false;

  final AuthModel authModel = AuthModelImpl();
  final AppModel _appModel = AppModelImpl();

  ProfileBloc() {
    getData();
  }

  void getData() {
    _showLoading();
    _appModel.getUserDataFromFirestore().then((value) {
      currentUser = value;
      loadInitialData();
      _notifySafely();
    }).whenComplete(() => _hideLoading());
  }

  void loadInitialData() {
    email = currentUser?.email ?? "";
    name = currentUser?.name ?? "";
    phone = currentUser?.phone ?? "";
    dob = currentUser?.dob ?? "";
    gender = currentUser?.gender ?? kGenderMale;
    List<String> parts = (currentUser?.dob ?? "").split('/');

    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);

    int year = int.parse(parts[2]);

    this.day = day.toString();
    this.month = month.toString();
    monthHintText = monthNames[month - 1];
    this.year = year.toString();
    _notifySafely();
  }

  Future<void> onTapConfirm() async {
    _showLoading();

    final UserVO newUser = currentUser!.copyWith(
      name: name,
      phone: phone,
      gender: gender,
      dob: "$day/$month/$year",
    );

    return authModel.editUserData(newUser);
  }

  int getMonthNumber(String monthName) {
    return monthNames.indexOf(monthName) + 1;
  }

  void onChangeName(String text) {
    name = text;
    _notifySafely();
  }

  void onChangeEmail(String text) {
    email = text;
    _notifySafely();
  }

  void onChangePhone(String text) {
    phone = text;
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

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
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
