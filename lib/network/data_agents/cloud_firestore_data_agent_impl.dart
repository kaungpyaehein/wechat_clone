import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/network/data_agents/wechat_app_data_agent.dart';

/// firestore
const otpCollection = "otp";
const usersCollection = "users";
const contactCollection = "contacts";
const momentCollection = "moments";
const commentCollection = "comments";
const likeCollection = "likes";

/// realtime database paths
const chatPath = "chats";

/// File Upload References
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

  /// Realtime Database
  var databaseRef = FirebaseDatabase.instance.ref();

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

  Stream<UserVO> getUserStreamFromFirestore(String userId) {
    final userDocStream =
        _firestore.collection(usersCollection).doc(userId).snapshots();
    final contactDocsStream = _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(contactCollection)
        .snapshots();

    return userDocStream.switchMap((userDocSnapshot) {
      if (userDocSnapshot.exists) {
        return contactDocsStream.map((contactQuerySnapshot) {
          final List<UserVO> contacts = contactQuerySnapshot.docs
              .map((contactDoc) => UserVO.fromJson(contactDoc.data()))
              .toList();

          return UserVO.fromJson(userDocSnapshot.data()!)
              .copyWith(contacts: contacts);
        });
      } else {
        return Stream.error(
            "Error fetching user data: Document does not exist");
      }
    });
  }

  @override
  Stream<List<MomentVO>> getMoments() {
    return _firestore
        .collection(momentCollection)
        .orderBy("momentId", descending: true)
        .snapshots()
        .asyncExpand((querySnapshot) {
      // Create a list of streams for each document's changes.
      List<Stream<MomentVO>> documentStreams = querySnapshot.docs.map((doc) {
        // Stream for the document itself
        Stream<MomentVO?> momentStream = doc.reference
            .snapshots()
            .where((documentSnapshot) => documentSnapshot.exists)
            .map((documentSnapshot) {
          return MomentVO.fromJson(
              documentSnapshot.data() as Map<String, dynamic>);
        });

        // Stream for the comments collection
        Stream<List<CommentVO>> commentsStream = doc.reference
            .collection(commentCollection)
            .snapshots()
            .map((commentsSnapshot) {
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

  @override
  Future<void> sendMessage(MessageVO messageVO, String receiverId) async {
    /// Save message to sender side
    await databaseRef.child("chats").update({
      "${messageVO.senderId}/$receiverId/${messageVO.timeStamp}":
          messageVO.toJson(),
    });

    /// Save message to receiver side
    await databaseRef.child("chats").update({
      "$receiverId/${messageVO.senderId}/${messageVO.timeStamp}":
          messageVO.toJson(),
    });
  }

  @override
  Stream<List<MessageVO>> getChatDetails(String senderId, String receiverId) {
    /// GET MESSAGE Snapshots
    return databaseRef
        .child("chats/$senderId/$receiverId")
        .orderByChild("timeStamp")
        .onValue
        .map((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      var values = dataSnapshot.value as Map<dynamic, dynamic>?;

      List<MessageVO> messages = [];

      /// Type cast each snapshot to a MessageVO
      if (values != null) {
        values.forEach((key, value) {
          messages.add(MessageVO.fromJson({
            ...value,
            'id': key,
          }));
        });
        messages.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      }

      return messages;
    });
  }

  @override
  Future<List<String>> getChatIdList(String currentUserId) {
    return databaseRef.child("$chatPath/$currentUserId").onValue.map((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      var values = dataSnapshot.value as Map<dynamic, dynamic>?;

      List<String> keyList = [];

      // Type cast each snapshot to key list
      if (values != null) {
        values.forEach((key, value) {
          keyList.add(key.toString());
        });
      }

      return keyList;
    }).first;
  }

  @override
  Stream<MessageVO?> getLastMessageByChatId(
      String chatId, String currentUserId) {
    return databaseRef
        .child("$chatPath/$currentUserId/$chatId")
        .orderByChild("id")
        .limitToLast(1)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        /// CONVERT SNAPSHOT TO JSON
        Map<String, dynamic> jsonString =
            json.decode(jsonEncode(event.snapshot.value).toString());

        //// CONVERT Json TO MAP ENTRY
        MapEntry<String, dynamic> messageDate = jsonString.entries.first;

        return MessageVO.fromJson(messageDate.value);
      } else {
        return null; // No messages found
      }
    }).handleError((error) {
      return null;
    });
  }
}
