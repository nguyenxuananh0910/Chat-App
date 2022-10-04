import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/kind_of_file.dart';

class Message {
  final String chatid;
  final String sendby;
  final String time;
  final String message;
  final int type;

  final String? url;

  Message(
      {required this.chatid,
      required this.sendby,
      required this.time,
      required this.message,
      required this.type,
      this.url});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'send by': sendby,
      'time': time,
      'type': type,
      if (url != null) 'url': url,
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    int type = doc.get('type');
    return Message(
      chatid: doc.id,
      sendby: doc.get('sendby'),
      time: doc.get('time').toString(),
      message: doc.get('message'),
      type: doc.get('type'),
      url: type == fileType ? doc.get('url') : null,
    );
  }
}
