import 'dart:async';

import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListmessageController extends GetxController {
  RxList<GroupModel> group = RxList<GroupModel>([]);
  Rxn<UserInfoModel> user = Rxn<UserInfoModel>();
  final AuthenService auThenService = Get.find();
  final MessageService messageService = Get.find();
  @override
  void onInit() {
    super.onInit();
    group.bindStream(messageService.getAllChat(auThenService.currentUser!.uid));
  }

  Future<DocumentSnapshot> showInfoRecevier(List groupchat) async {
    String a = '';
    for (var item in groupchat) {
      if (item.toString() != auThenService.currentUser!.uid) {
        a = item.toString().trim();
      }
    }
    return await FirebaseFirestore.instance.collection('users').doc(a).get();
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
}
