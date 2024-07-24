import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';

const otpCollection = "otp";
const usersCollection = "users";
const contactCollection = "contacts";
const momentCollection = "moments";
const commentCollection = "comments";
const likeCollection = "likes";
const fileUploadRef = "upload";

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

  /// Storage
  var firebaseStorage = FirebaseStorage.instance;

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
    return auth.signInWithEmailAndPassword(email: email, password: password);
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
            .collection(contactCollection)
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

  @override
  Future logOut() {
    return auth.signOut();
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  @override
  Future<void> updateUserInfo(UserVO userVO) {
    return _firestore
        .collection(
          usersCollection,
        )
        .doc(
          userVO.id.toString(),
        )
        .set(
          userVO.toJson(),
        );
  }

  @override
  Future<UserVO> getUserDataFromFirebase() async {
    final user = auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDoc =
          await _firestore.collection(usersCollection).doc(userId).get();
      final contactDocs = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(contactCollection)
          .get();
      if (userDoc.exists) {
        final List<UserVO> contacts = contactDocs.docs
            .map((contact) => UserVO.fromJson(
                  contact.data(),
                ))
            .toList();

        return UserVO.fromJson(userDoc.data()!).copyWith(contacts: contacts);
      } else {
        return Future.error(
            "Error fetching user data: Document does not exist");
      }
    } else {
      return Future.error("Error fetching user data: User not logged in");
    }
  }

  @override
  // Stream<List<MomentVO>> getMoments() {
  //   return _firestore
  //       .collection(momentCollection)
  //       .snapshots()
  //       .asyncMap((querySnapshot) async {
  //     List<MomentVO> moments = [];
  //
  //     for (var doc in querySnapshot.docs) {
  //       try {
  //         var moment = MomentVO.fromJson(doc.data());
  //
  //         // Fetch comments data
  //         var commentsSnapshot =
  //             await doc.reference.collection(commentCollection).get();
  //         var commentsData = commentsSnapshot.docs.map((subDoc) {
  //           return CommentVO.fromJson(subDoc.data());
  //         }).toList();
  //
  //         moment.comments = commentsData;
  //         moments.add(moment);
  //       } catch (e) {
  //         print("Error processing document ${doc.id}: $e");
  //       }
  //     }
  //
  //     return moments;
  //   });
  // }
  // Stream<List<MomentVO>> getMoments() {
  //   return _firestore
  //       .collection(momentCollection)
  //       .snapshots()
  //       .asyncMap((querySnapshot) async {
  //     List<MomentVO> moments = [];
  //
  //     for (var doc in querySnapshot.docs) {
  //       try {
  //         var moment = MomentVO.fromJson(doc.data());
  //
  //         // Fetch comments data
  //         var commentsSnapshot =
  //             await doc.reference.collection(commentCollection).get();
  //         var commentsData = commentsSnapshot.docs.map((subDoc) {
  //           return CommentVO.fromJson(subDoc.data());
  //         }).toList();
  //
  //         // Fetch likes data
  //         var likesSnapshot =
  //             await doc.reference.collection(likeCollection).get();
  //         var likesData =
  //             likesSnapshot.docs.map((subDoc) => subDoc.id).toList();
  //
  //         moment.comments = commentsData;
  //         moment.likes = likesData;
  //         moments.add(moment);
  //       } catch (e) {
  //         print("Error processing document ${doc.id}: $e");
  //       }
  //     }
  //
  //     return moments;
  //   });
  // }

  Stream<List<MomentVO>> getMoments() {
    return _firestore
        .collection(momentCollection)
        .snapshots()
        .asyncExpand((querySnapshot) {
      // Create a list of streams for each document's changes.
      List<Stream<MomentVO>> documentStreams = querySnapshot.docs.map((doc) {
        // Stream for the document itself
        Stream<MomentVO> momentStream =
            doc.reference.snapshots().map((documentSnapshot) {
          MomentVO moment = MomentVO.fromJson(
              documentSnapshot.data() as Map<String, dynamic>);
          return moment;
        });

        // Stream for the comments collection
        Stream<List<CommentVO>> commentsStream = doc.reference
            .collection(commentCollection)
            .snapshots()
            .map((commentsSnapshot) => commentsSnapshot.docs
                .map((subDoc) => CommentVO.fromJson(subDoc.data()))
                .toList());

        // Stream for the likes collection
        Stream<List<String>> likesStream = doc.reference
            .collection(likeCollection)
            .snapshots()
            .map((likesSnapshot) =>
                likesSnapshot.docs.map((subDoc) => subDoc.id).toList());

        // Combine the moment, comments, and likes streams
        return Rx.combineLatest3(
          momentStream,
          commentsStream,
          likesStream,
          (MomentVO moment, List<CommentVO> comments, List<String> likes) {
            moment.comments = comments;
            moment.likes = likes;
            return moment;
          },
        );
      }).toList();

      // Combine all document streams into one stream of lists of moments
      return Rx.combineLatestList(documentStreams);
    });
  }

  @override
  Future<void> createNewMoment(MomentVO momentVO) async {
    try {
      final momentDocRef =
          _firestore.collection(momentCollection).doc(momentVO.momentId);

      // Add the new Moment
      await momentDocRef.set(momentVO.toJson());
    } catch (error) {
      throw Exception("Error creating moment: ${error.toString()}");
    }
  }

  @override
  Future<void> onAddComment(String momentId, CommentVO commentVO) async {
    try {
      final momentDocRef =
          _firestore.collection(momentCollection).doc(momentId);

      // Add NEW COMMENT
      await momentDocRef
          .collection(commentCollection)
          .doc(commentVO.commentId)
          .set(commentVO.toJson());
    } catch (error) {
      throw Exception("Error creating comment: ${error.toString()}");
    }
  }

  @override
  Future<void> onTapLike(String momentId, String userId) async {
    try {
      final momentDocRef = _firestore.collection(momentCollection).doc(momentId);
      final likeDocRef = momentDocRef.collection(likeCollection).doc(userId);

      // Check if the like document already exists
      final likeDocSnapshot = await likeDocRef.get();

      if (likeDocSnapshot.exists) {
        // If the like already exists, remove it (unlike)
        await likeDocRef.delete();
      } else {
        // If the like does not exist, add it (like)
        await likeDocRef.set({});
      }
    } catch (error) {
      throw Exception("Error toggling like: ${error.toString()}");
    }
  }

}
