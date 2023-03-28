import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class GroupController extends GetxController {
  // final currentUser = Auth().currentUser;
  RxList<GroupModel> group = RxList<GroupModel>([]);
  AuthenService auThenService = AuthenRepo();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MessageService messageService = Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    group.bindStream(
        messageService.getAllChatGroup(auThenService.currentUser!.uid));
  }

  Future<DocumentSnapshot> showInfoReceVier(List groupchat) {
    String a = '';
    for (var item in groupchat) {
      if (item.toString() != auThenService.currentUser!.uid) {
        a = item.toString().trim();
      }
    }
    return FirebaseFirestore.instance.collection('users').doc(a).get();
  }

  Future<DocumentSnapshot> updateLastMess(String lastmessages) async {
    return await FirebaseFirestore.instance
        .collection('messages')
        .doc(lastmessages)
        .get();
  }

  Future<DocumentSnapshot> showUser(String senby) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(senby)
        .get();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
