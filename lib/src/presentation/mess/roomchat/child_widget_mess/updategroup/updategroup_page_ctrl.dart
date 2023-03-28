import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/message_service.dart';
import 'package:chatappdemo/src/presentation/pages/root_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateGroupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  String? idChat;
  String? idGroupChat;
  final AuthenService _auThenService = Get.find();
  Rxn<GroupModel> group = Rxn<GroupModel>();
  final MessageService messageService = Get.find();
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    idChat = Get.arguments['idChat'];
    // TODO: implement onInit
    super.onInit();
    idGroupChat = idChat;
    group.bindStream(messageService.getGroup(idGroupChat!));
  }

  String getUserId() => _auThenService.currentUser?.uid ?? '';

  void changeName() {
    FocusManager.instance.primaryFocus?.unfocus();
    final newName = nameController.text.trim();
    var collection = FirebaseFirestore.instance.collection('group');
    collection.doc(idGroupChat).update({'groupName': newName});
  }

  // Future getGroupDetails() async {
  //   await _firestore.collection('group').doc(idGroupChat).get().then((chatMap) {
  //     membersList = chatMap['members'];
  //     print(membersList);
  //     isLoading = false;
  //   });
  // }

  Future removeMembers(int index) async {
    String? uid = group.value?.menber![index];
    List<String> memberList = group.value?.menber ?? [];
    memberList.removeAt(index);
    await _firestore.collection('group').doc(idGroupChat).update({
      "menber": memberList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('group')
          .doc(idGroupChat)
          .delete();
    });
    Get.back();
  }

  void showDialogBox(int index) {
    if (_auThenService.currentUser!.uid != group.value?.menber![index]) {
      Get.dialog(AlertDialog(
        title: const CustomText(
          text: 'Delete the member',
          fontWeight: FontWeight.w700,
          textSize: 20,
          textColor: Colors.black,
          textAlign: TextAlign.center,
        ),
        content: ListTile(
          onTap: () => removeMembers(index),
          title: const CustomText(
            text: 'Remove This Member',
            textSize: 18,
            textColor: Colors.red,
          ),
        ),
      ));
    }
  }

  Future onLeaveGroup() async {
    for (int i = 0; i < group.value!.menber!.length; i++) {
      if (group.value!.menber![i] == _auThenService.currentUser!.uid) {
        List memberList = group.value?.menber ?? [];
        memberList.removeAt(i);

        await _firestore.collection('group').doc(idGroupChat).update({
          "menber": memberList,
        });
      }
    }
    await _firestore
        .collection('users')
        .doc(_auThenService.currentUser!.uid)
        .collection('group')
        .doc(idGroupChat)
        .delete();

    Get.toNamed(RootApp.routerName);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
