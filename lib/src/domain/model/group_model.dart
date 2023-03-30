import 'package:cloud_firestore/cloud_firestore.dart';

/// id : ""
/// avataUrl : ""
/// chatType : ""
/// lastmessages : ""
/// menber : [""]

class GroupModel {
  GroupModel(
      {this.id,
      this.avataUrl,
      this.chatType,
      this.lastmessages,
      this.menber,
      this.groupName});

  GroupModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc.id;
    avataUrl = doc['avataUrl'];
    chatType = doc['chatType'];
    groupName = doc['groupName'];
    lastmessages = doc['lastmessages'];
    menber = doc['menber'] != null ? doc['menber'].cast<String>() : [];
  }
  String? id;
  String? avataUrl;
  String? chatType;
  String? groupName;
  String? lastmessages;
  List<String>? menber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['avataUrl'] = avataUrl;
    map['chatType'] = chatType;
    map['groupName'] = groupName;
    map['lastmessages'] = lastmessages;
    map['menber'] = menber;
    return map;
  }
}
