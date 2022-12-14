import 'dart:async';

import 'dart:io';
import 'package:chatappdemo/src/view/mess/updategroup.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/components/custom_text.dart';
import '../../../services/notifications.dart';
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
  File? imageFile;
  File? file;
  PlatformFile? pickfile;
  bool isloading = false;
  UploadTask? uploadTask;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = Auth().currentUser;
  String? idGroupChat;
  String? mgsa;
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
        // type: FileType.custom,
        // allowedExtensions: ['jpg', 'mp4', 'doc'],
        );
    if (result != null) {
      pickfile = result.files.first;
      uploadImage(File(pickfile!.path!));
    }
  }

  Future getCameraImages() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage(imageFile!);
      }
    });
  }

  Future uploadImage(File file) async {
    final path = 'file/${file.path.split('/').last}';

    int type = checkTypeOfFile(path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print('Dowlink: $urlDownload');
    }

    onSendMessage(type: type, fileName: urlDownload);
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

  void onSendMessage({required int type, String? fileName, String? url}) async {
    // tao groupid 2 user moi
    try {
      if (idGroupChat == null) {
        Map<String, dynamic> group = {
          "avataUrl": userTemple?['photoURL'],
          "chatType": 'Private',
          "groupName": "",
          "lastmessages": "",
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
      var idmessage = await _firestore.collection('messages').add(messages);
      // late mess
      Map<String, dynamic> groupupdate = {
        "lastmessages": idmessage.id,
      };
      await _firestore.collection('group').doc(idGroupChat).update(groupupdate);
    } else {
      if (kDebugMode) {
        print("Enter Some Text");
      }
    }

    LocalNotificationService.sendNotification(
        title: "new message", message: content, token: userTemple?['msgToken']);
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UpDateGroup(Idchat: idGroupChat)));
                },
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      height: 70,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      selectFile();
                    },
                    child: Row(children: [
                      const Icon(
                        Icons.photo_library,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("Gallery",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      getCameraImages();
                    },
                    child: Row(children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("Camera",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Row(children: [
                      const Icon(
                        Icons.attach_file_sharp,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("File",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
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
                  text: userTemple?['name'],
                  textSize: 25,
                  textColor: AppColor.white,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  text: userTemple?['status'],
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
