import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/user_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  // final currentUser = Auth().currentUser;

  final user = FirebaseAuth.instance.currentUser;
  RxList<UserInfoModel> users = RxList<UserInfoModel>([]);
  final UserService _userService = Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    users.bindStream(_userService.getAllUser());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
