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
      return getUserDataFromFirestore(userId);
    } else {
      return Future.error("Error fetching user data: User not logged in");
    }
  }

  Future<UserVO> getUserDataFromFirestore(String userId) async {
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
      return Future.error("Error fetching user data: Document does not exist");
    }
  }

  @override
  // Stream<List<MomentVO>> getMoments() {
  //   return _firestore
  //       .collection(momentCollection)
  //       .snapshots()
  //       .asyncExpand((querySnapshot) {
  //     // Create a list of streams for each document's changes.
  //     List<Stream<MomentVO>> documentStreams = querySnapshot.docs.map((doc) {
  //       // Stream for the document itself
  //       Stream<MomentVO> momentStream =
  //           doc.reference.snapshots().map((documentSnapshot) {
  //         MomentVO moment = MomentVO.fromJson(
  //             documentSnapshot.data() as Map<String, dynamic>);
  //         return moment;
  //       });
  //
  //       // Stream for the comments collection
  //       Stream<List<CommentVO>> commentsStream = doc.reference
  //           .collection(commentCollection)
  //           .snapshots()
  //           .map((commentsSnapshot) => commentsSnapshot.docs
  //               .map((subDoc) => CommentVO.fromJson(subDoc.data()))
  //               .toList());
  //
  //       // Stream for the likes collection
  //       Stream<List<String>> likesStream = doc.reference
  //           .collection(likeCollection)
  //           .snapshots()
  //           .map((likesSnapshot) =>
  //               likesSnapshot.docs.map((subDoc) => subDoc.id).toList());
  //
  //       // Combine the moment, comments, and likes streams
  //       return Rx.combineLatest3(
  //         momentStream,
  //         commentsStream,
  //         likesStream,
  //         (MomentVO moment, List<CommentVO> comments, List<String> likes) {
  //           moment.comments = comments;
  //           moment.likes = likes;
  //           return moment;
  //         },
  //       );
  //     }).toList();
  //
  //     // Combine all document streams into one stream of lists of moments
  //     return Rx.combineLatestList(documentStreams);
  //   });
  // }
  Stream<List<MomentVO>> getMoments() {
    return _firestore
        .collection(momentCollection)
        .snapshots()
        .asyncExpand((querySnapshot) {
      print('Collection snapshot updated');

      // Create a list of streams for each document's changes.
      List<Stream<MomentVO>> documentStreams = querySnapshot.docs.map((doc) {
        print('Document found: ${doc.id}');

        // Stream for the document itself
        Stream<MomentVO?> momentStream =
            doc.reference.snapshots().map((documentSnapshot) {
          if (documentSnapshot.exists && documentSnapshot.data() != null) {
            print('Moment snapshot updated: ${documentSnapshot.data()}');
            return MomentVO.fromJson(
                documentSnapshot.data() as Map<String, dynamic>);
          } else {
            // Handle the case where the document doesn't exist or data is null
            print(
                'Moment document does not exist or data is null for doc id: ${doc.id}');
            return null; // Return null to indicate the document is invalid
          }
        });

        // Stream for the comments collection
        Stream<List<CommentVO>> commentsStream = doc.reference
            .collection(commentCollection)
            .snapshots()
            .map((commentsSnapshot) {
          print('Comments snapshot updated for document: ${doc.id}');
          return commentsSnapshot.docs.map((subDoc) {
            print('Comment found: ${subDoc.data()}');
            return CommentVO.fromJson(subDoc.data());
          }).toList();
        });

        // Stream for the likes collection
        Stream<List<String>> likesStream = doc.reference
            .collection(likeCollection)
            .snapshots()
            .map((likesSnapshot) {
          print('Likes snapshot updated for document: ${doc.id}');
          return likesSnapshot.docs.map((subDoc) {
            print('Like found: ${subDoc.id}');
            return subDoc.id;
          }).toList();
        });

        // Combine the moment, comments, and likes streams
        return Rx.combineLatest3<MomentVO?, List<CommentVO>, List<String>,
            MomentVO>(
          momentStream,
          commentsStream,
          likesStream,
          (MomentVO? moment, List<CommentVO> comments, List<String> likes) {
            if (moment != null) {
              moment.comments = comments;
              moment.likes = likes;
              return moment;
            } else {
              throw Exception('Moment data is null');
            }
          },
        );
      }).toList();

      // Combine all document streams into one stream of lists of moments
      return Rx.combineLatestList<MomentVO>(documentStreams).map((moments) {
        print('Moments list updated: $moments');
        return moments;
      });
    });
  }
  // Stream<List<MomentVO>> getMoments() async* {
  //   // Listen to the collection snapshot.
  //   await for (var querySnapshot in _firestore.collection(momentCollection).snapshots()) {
  //     // List of Futures for each document.
  //     List<Future<MomentVO>> momentFutures = querySnapshot.docs.map((doc) async {
  //       // Get the moment document data.
  //       var documentSnapshot = await doc.reference.get();
  //       MomentVO moment = MomentVO.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  //
  //       // Get the comments for the moment.
  //       var commentsSnapshot = await doc.reference.collection(commentCollection).get();
  //       moment.comments = commentsSnapshot.docs.map((subDoc) => CommentVO.fromJson(subDoc.data())).toList();
  //
  //       // Get the likes for the moment.
  //       var likesSnapshot = await doc.reference.collection(likeCollection).get();
  //       moment.likes = likesSnapshot.docs.map((subDoc) => subDoc.id).toList();
  //
  //       return moment;
  //     }).toList();
  //
  //     // Wait for all moment futures to complete.
  //     List<MomentVO> moments = await Future.wait(momentFutures);
  //     yield moments;
  //   }
  // }

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
      final momentDocRef =
          _firestore.collection(momentCollection).doc(momentId);
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

  @override
  Future<void> addNewFriend(UserVO myUserInfo, String newFriendId) async {
    try {
      final myUserDoc =
          _firestore.collection(usersCollection).doc(myUserInfo.id);
      final newFriendDoc =
          _firestore.collection(usersCollection).doc(newFriendId);

      // Get new friend's info
      final UserVO newFriendUserVO =
          await getUserDataFromFirestore(newFriendId);

      // Ensure new friend's data is retrieved
      if (newFriendUserVO.id?.isEmpty ?? false) {
        throw Exception("New friend not found");
      } // Check if the contact already exists for both users
      final myContactDoc =
          myUserDoc.collection(contactCollection).doc(newFriendId);
      final newFriendContactDoc =
          newFriendDoc.collection(contactCollection).doc(myUserInfo.id);
      final myContactSnapshot = await myContactDoc.get();
      final newFriendContactSnapshot = await newFriendContactDoc.get();

      // If contact already exists, do not add
      if (myContactSnapshot.exists || newFriendContactSnapshot.exists) {
        throw Exception("Contact already exists");
      }

      // Add user info to respective docs
      await Future.wait([
        myUserDoc
            .collection(contactCollection)
            .doc(newFriendId)
            .set(newFriendUserVO.copyWith(contacts: []).toJson()),
        newFriendDoc
            .collection(contactCollection)
            .doc(myUserInfo.id)
            .set(myUserInfo.copyWith(contacts: []).toJson()),
      ]);
    } catch (error) {
      throw Exception("Error adding new friend: ${error.toString()}");
    }
  }

  // @override
  // Future addNewFriend(UserVO myUserInfo, String newFriendId) async {
  //   final myUserDoc = _firestore.collection(usersCollection).doc(myUserInfo.id);
  //   final newFriendDoc =
  //       _firestore.collection(usersCollection).doc(newFriendId);
  //
  //   /// get new friend's infos
  //
  //   final UserVO newFriendUserV0 = await getUserDataFromFirestore(newFriendId);
  //
  //   /// add use info to respective doc
  //   return Future.wait([
  //     myUserDoc
  //         .collection(contactCollection)
  //         .doc(newFriendId)
  //         .set(newFriendUserV0.toJson()),
  //     newFriendDoc
  //         .collection(contactCollection)
  //         .doc(myUserInfo.id)
  //         .set(myUserInfo.toJson()),
  //   ]).catchError((error) {
  //     throw Exception("Error adding new friend: ${error.toString()}");
  //   });
  // }
}
