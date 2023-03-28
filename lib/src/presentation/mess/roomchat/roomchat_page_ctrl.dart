import 'dart:async';
import 'dart:io';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:chatappdemo/utils/kind_of_file.dart';
import 'package:chatappdemo/utils/notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomChatController extends GetxController {
  String? groupchatId;
  List? listMenber;
  File? imageFile;
  File? file;
  PlatformFile? pickfile;
  RxBool isloading = false.obs;
  UploadTask? uploadTask;
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final currentUser = Auth().currentUser;
  String? idGroupChat;
  String? mgsa;
  DocumentSnapshot? userTemple;
  AuthenService authenService = AuthenRepo();
  RxList<MessageModel> roomChat = RxList<MessageModel>([]);
  final MessageService messageService = Get.find();
  @override
  void onInit() {
    groupchatId = Get.arguments['groupchatId'];
    listMenber = Get.arguments['listMenber'];
    // TODO: implement onInit
    super.onInit();
    showInfoRecevier();
    idGroupChat = groupchatId;
    if (idGroupChat != null) {
      roomChat.bindStream(messageService.getALlMessage(groupchatId!));
    }
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

  Stream<DocumentSnapshot> showInfoRecevier() {
    String a = '';
    for (var item in listMenber ?? []) {
      if (item.toString() != authenService.currentUser!.uid) {
        a = item.toString().trim();
      }
    }

    return FirebaseFirestore.instance.collection('users').doc(a).snapshots();
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
            authenService.currentUser!.uid.toString(),
            userTemple!.id.toString()
          ],
        };
        idGroupChat = (await firestore.collection('group').add(group)).id;
        // setState(() {});
      }
    } catch (e) {
      return null;
    }

    // gui mess
    String content = '';
    if (type == messageType) {
      content = message.text.trim();
    } else {
      content = fileName!;
    }
    if (content.isNotEmpty) {
      Map<String, dynamic> messages = {
        "chatId": idGroupChat,
        "sendby": authenService.currentUser!.uid,
        "message": content,
        "type": type,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      };

      message.clear();
      var idmessage = await firestore.collection('messages').add(messages);
      // late mess
      Map<String, dynamic> groupupdate = {
        "lastmessages": idmessage.id,
      };
      await firestore.collection('group').doc(idGroupChat).update(groupupdate);
    } else {
      if (kDebugMode) {
        print("Enter Some Text");
      }
    }

    LocalNotificationService.sendNotification(
        title: "new message", message: content, token: userTemple?['msgToken']);
  }
}
