import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';

const otpCollection = "otp";
const usersCollection = "users";

class CloudFirestoreDataAgentImpl extends WechatDataAgent {
  /// SETUP SINGLETON
  static final CloudFirestoreDataAgentImpl _singleton =
      CloudFirestoreDataAgentImpl._internal();

  factory CloudFirestoreDataAgentImpl() {
    return _singleton;
  }

  CloudFirestoreDataAgentImpl._internal();

  /// Database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<String> getOtpCode() {
    return _firestore
        .collection(otpCollection)
        .doc(otpCollection)
        .get()
        .then((doc) {
      if (doc.exists) {
        return doc["otp_code"];
      }
      return "";
    });
  }

  @override
  Future login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  Future<void> addNewUser(UserVO newUser) {
    final userDocRef =
        _firestore.collection(usersCollection).doc(newUser.id.toString());

    return Future.wait([
      /// ADD USER INFO
      userDocRef.set(newUser.copyWith(contacts: []).toJson()),

      /// ADD CONTACTS COLLECTION
      ...newUser.contacts!.map((contact) {
        return userDocRef
            .collection("contacts")
            .doc(contact.id)
            .set(contact.toJson());
      })
    ]);
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) => credential.user?..updateDisplayName(newUser.name))
        .then((user) {
      newUser.id = user?.uid ?? "";
      addNewUser(newUser);
    });
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }
}
