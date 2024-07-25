import 'package:flutter/foundation.dart';
import 'package:wechat_clone/data/models/app_model.dart';
import 'package:wechat_clone/data/models/app_model_impl.dart';

class ScanQRBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;

  bool isDisposed = false;

  /// Model
  final AppModel _model = AppModelImpl();

  Future onDetectData(String newFriendId) {
    print("processing");
    _showLoading();
    return _model.addNewFriend(newFriendId).whenComplete(() => _hideLoading());
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
