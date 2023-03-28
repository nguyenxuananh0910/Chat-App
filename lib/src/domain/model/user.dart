import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  UserInfoModel({
    this.status,
    this.idUsers,
    this.name,
    this.urlAvatar = '',
    this.msgToken,
  });
  UserInfoModel.fromDocument(DocumentSnapshot document) {
    idUsers = document.id;
    name = document.get('name');
    status = document.get('status');
    urlAvatar = document.get('photoURL');
    if (document.get('msgToken') != null) {
      msgToken = List.generate(document.get('msgToken').length,
          (index) => document.get('msgToken')[index].toString());
    }
  }
  String? idUsers;
  String? name;
  String? urlAvatar;
  List<String>? msgToken;
  String? status;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoURL': urlAvatar,
      'msgToken': msgToken,
      'status': status,
    };
  }

  // factory UserInfo.fromJson(Map<String, dynamic> json) {
  //   return UserInfo(
  //     idUsers: json['id'],
  //     name: json['name'],
  //     urlAvatar: json['photoURL'],
  //     msgToken: json['msgToken'].cast<String>(),
  //     status: json['status'],
  //   );
  // }
}
