import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String idUsers;
  final String name;
  final String urlAvatar;
  final List<String> msgToken;
  final String status;

  UserInfo({
    required this.status,
    required this.idUsers,
    required this.name,
    this.urlAvatar = '',
    required this.msgToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoURL': urlAvatar,
      'msgToken': msgToken,
      'status': status,
    };
  }

  factory UserInfo.fromDocument(DocumentSnapshot document) {
    return UserInfo(
      idUsers: document.id,
      name: document.get('name'),
      status: document.get('status'),
      urlAvatar: document.get('photoURL'),
      msgToken: document.get('msgToken').cast<String>(),
    );
  }
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      idUsers: json['id'],
      name: json['name'],
      urlAvatar: json['photoURL'],
      msgToken: json['msgToken'].cast<String>(),
      status: json['status'],
    );
  }
}
