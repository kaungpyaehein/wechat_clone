import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/moment_model.dart';
import 'package:wechat_clone/data/models/moment_model_impl.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';

class MomentFeedsBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;

  bool isDisposed = false;

  List<MomentVO> moments = [];
  final MomentModel _momentModel = MomentModelImpl();
  StreamSubscription? _momentsSubscription;

  MomentFeedsBloc() {
    _momentsSubscription =
        _momentModel.getMomentsFromNetwork().listen((moments) {
      this.moments = moments;
      notifyListeners();
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
    _momentsSubscription!.cancel();
    isDisposed = true;
  }
}
