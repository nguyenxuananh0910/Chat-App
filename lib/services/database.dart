import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'api_path.dart';
import '../src/domain/user.dart';

abstract class Database {
  void saveUserInfo({required UserInfo userInfo});

  void updateUserAvatar({required String url});

  void updateUserName({required String newName});

  void addMsgToken({required String? token});

  void removeMsgToken({required String token});

  Future<List<String>> getMsgToken({required String id});

  Stream<QuerySnapshot> userStream({required String textSearch});

  Future<DocumentSnapshot> getUserInfo({required String id});
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({required this.uid});

  final String uid;
  String get userid => uid;
  @override
  void saveUserInfo({required UserInfo userInfo}) {
    try {
      final path = APIPath.user(userInfo.idUsers);
      final documentReference = FirebaseFirestore.instance.doc(path);
      documentReference.set(userInfo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot> userStream({required String textSearch}) {
    final path = APIPath.users();
    return FirebaseFirestore.instance
        .collection(path)
        .where('name', isEqualTo: textSearch)
        .snapshots();
  }

  @override
  Future<DocumentSnapshot> getUserInfo({required String id}) async {
    final path = APIPath.user(id);
    return await FirebaseFirestore.instance.doc(path).get();
  }

  @override
  void updateUserAvatar({required String url}) {
    final path = APIPath.user(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({'photoURL': url});
  }

  @override
  void updateUserName({required String newName}) {
    final path = APIPath.user(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({'name': newName});
  }

  @override
  void addMsgToken({required String? token}) {
    if (token == null) return;
    final path = APIPath.user(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({
      'msgToken': FieldValue.arrayUnion([token])
    });
  }

  @override
  void removeMsgToken({required String token}) {
    final path = APIPath.user(uid);
    final documentReference = FirebaseFirestore.instance.doc(path);
    documentReference.update({
      'msgToken': FieldValue.arrayRemove([token])
    });
  }

  @override
  Future<List<String>> getMsgToken({required String id}) async {
    final path = APIPath.user(id);
    final documentSnapshot = await FirebaseFirestore.instance.doc(path).get();
    return documentSnapshot.get('msgToken').cast<String>();
  }
}
