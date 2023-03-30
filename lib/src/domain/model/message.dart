import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/kind_of_file.dart';

class MessageModel {
  MessageModel(
      {this.chatid, this.sendby, this.time, this.message, this.type, this.url});
  MessageModel.fromDocument(DocumentSnapshot doc) {
    // type = doc.get('type');
    chatid = doc.id;
    sendby = doc.get('sendby');
    time = doc.get('time');
    message = doc.get('message');
    type = doc.get('type');
    url = type == fileType ? doc.get('url') : null;
  }
  String? chatid;
  String? sendby;
  String? time;
  String? message;
  int? type;
  String? url;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'send by': sendby,
      'time': time,
      'type': type,
      if (url != null) 'url': url,
    };
  }
}
