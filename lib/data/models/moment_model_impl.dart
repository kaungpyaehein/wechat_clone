import 'dart:io';

import 'package:wechat_clone/data/models/moment_model.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/network/data_agents/cloud_firestore_data_agent_impl.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';
import 'package:wechat_clone/persistence/daos/user_dao.dart';

class MomentModelImpl extends MomentModel {
  final WechatDataAgent wechatDataAgent = CloudFirestoreDataAgentImpl();
  final UserDao userDao = UserDao();

  @override
  Future<void> createNewMoment(MomentVO momentVO) {
    return wechatDataAgent.createNewMoment(momentVO);
  }

  @override
  Future<String> uploadPhotoToFirebase(File? file) {
    if (file != null) {
      return wechatDataAgent.uploadFileToFirebase(file);
    }
    return Future.error("Upload Failed");
  }

  @override
  Stream<List<MomentVO>> getMomentsFromNetwork() {
   return wechatDataAgent.getMoments();
  }
}
