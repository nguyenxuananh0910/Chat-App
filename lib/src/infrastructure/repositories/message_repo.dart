import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepo implements MessageService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Stream<List<GroupModel>> getAllChat(uid) {
    return FirebaseFirestore.instance
        .collection('group')
        .where('chatType', isEqualTo: "Private")
        .where('menber', arrayContains: uid)
        .snapshots()
        .map((query) => query.docs
            .map((item) => GroupModel.fromDocumentSnapshot(item))
            .toList());
  }

  @override
  Stream<List<GroupModel>> getAllChatGroup(uid) {
    return FirebaseFirestore.instance
        .collection('group')
        .where('chatType', isEqualTo: "Group")
        .where('menber', arrayContains: uid)
        .snapshots()
        .map((query) => query.docs
            .map((item) => GroupModel.fromDocumentSnapshot(item))
            .toList());
  }

  @override
  Stream<List<MessageModel>> getALlMessage(idGroupChat) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: idGroupChat)
        .orderBy('time', descending: true)
        .snapshots()
        .map((query) =>
            query.docs.map((item) => MessageModel.fromDocument(item)).toList());
  }

  @override
  Stream<GroupModel> getGroup(String idChat) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(idChat)
        .snapshots()
        .map((item) => GroupModel.fromDocumentSnapshot(item));
  }
}
