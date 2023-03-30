import 'dart:io';
import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/user_repo.dart';
import 'package:chatappdemo/src/presentation/login/login_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../../domain/services/user_service.dart';
import '../../../utils/storage_database.dart';

class ProfileController extends GetxController {
  final AuthenService _authenService = Get.find();
  final UserService userService = UserRepo();
  late final UserService database;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<UserInfoModel> users = <UserInfoModel>[].obs;
  Rxn<UserInfoModel> user = Rxn<UserInfoModel>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(userService.getUser(_authenService.currentUser!.uid));
  }

  UploadTask? uploadFile(File file) {
    final currentUser = _authenService.currentUser!;
    final fileName = basename(file.path);
    final destination = 'avatar/${currentUser.uid}/$fileName';
    return StorageDatabase.uploadFile(destination, file);
  }

  Future<void> updateAvatar(String url) async {
    final currentUser = _authenService.currentUser!;
    await currentUser.updatePhotoURL(url);
    database.updateUserAvatar(url: url);
  }

  void updateName(String name) {
    final currentUser = _authenService.currentUser!;
    currentUser.updateDisplayName(name);
    database.updateUserName(newName: name);
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(LoginPageView.routerName);
  }
}
