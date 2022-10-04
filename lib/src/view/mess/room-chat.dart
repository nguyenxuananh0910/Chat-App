import 'dart:async';

import 'package:chatappdemo/theme/colors.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/components/custom_text.dart';
import '../../../services/auth.dart';

import '../../domain/message.dart';
import 'customchat/chat_case.dart';

class ChatApp extends StatefulWidget {
  final String groupchatId;
  final List listMenber;
  const ChatApp({
    Key? key,
    required this.groupchatId,
    required this.listMenber,
  }) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final StreamController<DocumentSnapshot> _showinfo =
      StreamController<DocumentSnapshot>();
  bool isloading = false;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = Auth().currentUser;
  // final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    showInfoRecevier();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "chatId": widget.groupchatId,
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "type": int.parse('1'),
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      _message.clear();
      await _firestore.collection('messages').add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  Stream<DocumentSnapshot> showInfoRecevier() {
    String a = '';
    for (var item in widget.listMenber) {
      if (item.toString() != currentUser!.uid) {
        a = item.toString().trim();
      }
    }
    // var rs = await FirebaseFirestore.instance.collection('users').doc(a).get();
    // _showinfo.sink.add(rs);
    return FirebaseFirestore.instance.collection('users').doc(a).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.square(65),
          child: AppBar(
            title: StreamBuilder<DocumentSnapshot>(
                stream: showInfoRecevier(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Column(
                      children: [
                        CustomText(
                          text: snapshot.data?['name'],
                          textSize: 25,
                          textColor: AppColor.white,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: snapshot.data?['status'],
                          textSize: 12,
                          textColor: AppColor.white,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    );
                  }
                  return Container();
                }),
            backgroundColor: AppColor.loyalBlue,
            elevation: 0.0,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 10,
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('chatId', isEqualTo: widget.groupchatId)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      reverse: true, //dao chieu list
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var a = snapshot.data!.docs[index];
                        final Message message = Message.fromDocument(a);
                        bool isMe = message.sendby == currentUser!.uid;
                        return ChatBubble(message: message, isMe: isMe);
                      });
                } else {
                  return Container();
                }
              },
            )),
            const SizedBox(
              height: kBottomNavigationBarHeight + 30,
            ),
          ],
        ),
        getBottomBar()
      ],
    );
  }

  Widget getBottomBar() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200]!,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.attach_file_sharp,
              color: AppColor.primary,
              size: 25,
            ),
            const Icon(
              FontAwesomeIcons.image,
              color: AppColor.primary,
              size: 25,
            ),
            Container(
              width: size.width * 0.69,
              decoration: BoxDecoration(
                  color: AppColor.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: TextField(
                  maxLines: 1,
                  controller: _message,
                  onSubmitted: (value) => onSendMessage(),
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    color: AppColor.black,
                  ),
                  cursorColor: AppColor.primary,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: onSendMessage,
                child: const Icon(
                  Icons.send,
                  color: AppColor.primary,
                  size: 28,
                )),
          ],
        ),
      ),
    );
  }
}
