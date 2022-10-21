import 'dart:async';

import 'dart:io';

import 'package:chatappdemo/src/view/groupchat/adduser_ui.dart';
import 'package:chatappdemo/src/view/mess/uploadfile.dart';
import 'package:chatappdemo/theme/colors.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/components/custom_text.dart';
import '../../../services/auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../../utils/kind_of_file.dart';
import '../../domain/message.dart';
import 'customchat/chat_case.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatApp extends StatefulWidget {
  final String? groupchatId;
  final List? listMenber;
  const ChatApp({
    Key? key,
    required this.groupchatId,
    required this.listMenber,
  }) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  bool isloading = false;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = Auth().currentUser;
  String? idGroupChat;
  DocumentSnapshot? userTemple;
  @override
  void initState() {
    idGroupChat = widget.groupchatId;
    showInfoRecevier();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'mp4', 'doc'],
    );
    if (result != null) {
      pickfile = result.files.first;
      uploadImage();
    }
  }

  Future uploadImage() async {
    final path = 'file/${pickfile!.name}';
    final file = File(pickfile!.path!);
    int type = checkTypeOfFile(path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Dowlink: $urlDownload');

    onSendMessage(type: type, fileName: urlDownload);
  }

  void onSendMessage({required int type, String? fileName, String? url}) async {
    // tao groupid 2 user moi
    try {
      if (idGroupChat == null) {
        Map<String, dynamic> group = {
          "avataUrl": userTemple?['photoURL'],
          "chatType": 'Private',
          "groupName": "",
          "menber": [
            _auth.currentUser!.uid.toString(),
            userTemple!.id.toString()
          ],
        };
        idGroupChat = (await _firestore.collection('group').add(group)).id;
        setState(() {});
      }
    } catch (e) {}

    // gui mess
    String content = '';
    if (type == messageType) {
      content = _message.text.trim();
    } else {
      content = fileName!;
    }
    if (content.isNotEmpty) {
      Map<String, dynamic> messages = {
        "chatId": idGroupChat,
        "sendby": _auth.currentUser!.uid,
        "message": content,
        "type": type,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      _message.clear();
      _firestore.collection('messages').add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  // show info
  Stream<DocumentSnapshot> showInfoRecevier() {
    String a = '';
    for (var item in widget.listMenber ?? []) {
      if (item.toString() != currentUser!.uid) {
        a = item.toString().trim();
      }
    }

    return FirebaseFirestore.instance.collection('users').doc(a).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.square(65),
          child: AppBar(
            title: idGroupChat != null
                ? StreamBuilder<DocumentSnapshot>(
                    key: UniqueKey(),
                    stream: FirebaseFirestore.instance
                        .collection('group')
                        .doc(idGroupChat)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const Text('Loading...');
                      // }
                      final groupchat = snapshot.data!;
                      if (groupchat['groupName'] != "") {
                        return CustomText(
                          text: groupchat['groupName'],
                          textSize: 25,
                          textColor: AppColor.white,
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return infochat();
                      }
                    },
                  )
                : infochat(),
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
                child: idGroupChat != null // check group
                    ? StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('messages')
                            .where('chatId', isEqualTo: idGroupChat)
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                                reverse: true, //dao chieu list
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var chat = snapshot.data!.docs[index];
                                  final Message message =
                                      Message.fromDocument(chat);
                                  bool isMe =
                                      message.sendby == currentUser!.uid;
                                  return ChatBubble(
                                      message: message, isMe: isMe);
                                });
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container()),
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => showFile()));
              },
              child: const Icon(
                FontAwesomeIcons.image,
                color: AppColor.primary,
                size: 25,
              ),
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
                  onSubmitted: (value) => onSendMessage(type: 1),
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
                onTap: () => onSendMessage(type: 1),
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

  Widget showFile() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      selectFile();
                    },
                    icon: const Icon(
                      Icons.photo_library,
                      size: 30,
                    )),
                const CustomText(
                  text: 'gallery',
                  textSize: 18,
                  textColor: AppColor.black,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      getCameraImages();
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                    )),
                const CustomText(
                  text: 'camera',
                  textSize: 18,
                  textColor: AppColor.black,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file_sharp,
                      size: 30,
                    )),
                const CustomText(
                  text: 'file',
                  textSize: 18,
                  textColor: AppColor.black,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infochat() {
    return StreamBuilder<DocumentSnapshot>(
        key: UniqueKey(),
        stream: showInfoRecevier(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userTemple = snapshot.data!; // lay thong tin user
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
        });
  }
}
