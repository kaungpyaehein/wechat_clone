import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';

class ChatListBloc extends ChangeNotifier {
  List<UserVO> contacts = [];

  /// State
  bool isLoading = false;

  bool isDisposed = false;
  final AppModel _appModel = AppModelImpl();

  UserVO? userVo;

  List<String> chatIdList = [];

  List<UserVO> activeChatList = [];

  ChatListBloc() {
    _showLoading();
    userVo = _appModel.getUserDataFromDatabase();
    contacts = userVo?.contacts ?? [];
    _notifySafely();
    _appModel
        .getChatIdList()
        .then((value) {
          chatIdList = value;
          _notifySafely();
        })
        .whenComplete(() => filterActiveChatUsers())
        .whenComplete(() => _hideLoading());
  }

  Stream getLatestMessageStreamByChatId(String chatId) {
    return _appModel.getLastMessageByChatId(chatId);
  }

  void filterActiveChatUsers() {
    activeChatList =
        contacts.where((contact) => chatIdList.contains(contact.id)).toList();
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
