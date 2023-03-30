import 'dart:io';

import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/domain/services/user_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:chatappdemo/src/presentation/account/profile_ctrl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  final AuthenService authenService = Get.find();
  // final currentUser = Auth().currentUser!;
  final ProfileController profileController = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newpass = TextEditingController();

  late UserService database;
  final RxString avatar = "".obs;
  final RxBool showPass = false.obs;
  final Rxn<UploadTask> task = Rxn<UploadTask>();
  bool isUploadNewAvatar = false;
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // database = context.read<UserService>();
    avatar.value = authenService.currentUser?.photoURL ?? '';
    nameController.text = authenService.currentUser?.displayName ?? "";
    // onToggleShowPass();
  }

  Future<void> onPressChangeImage() async {
    /// Pick and handle file
    final fileSelection = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (fileSelection == null) return;

    final path = fileSelection.files.single.path!;
    final file = File(path);
    task.value = profileController.uploadFile(file);
    // setState(
    //   () {
    //
    //   },
    // );

    final snapshot = await task.value!;
    final urlDownload = await snapshot.ref.getDownloadURL();
    profileController.updateAvatar(urlDownload);
    authenService.currentUser?.updatePhotoURL(urlDownload);
    Fluttertoast.showToast(msg: 'Update your avatar');
    task.value = null;
    avatar.value = urlDownload;
    // setState(() {
    //
    // });
  }

  void changeProfile() {
    FocusManager.instance.primaryFocus?.unfocus();
    final newName = nameController.text.trim();
    profileController.updateName(newName);
    Fluttertoast.showToast(msg: 'Your name have been changed');
  }

  void onToggleShowPass() {
    showPass.value = !showPass.value;
  }

  void changePassword(
      {required String currentPassword, required String newPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
      }).catchError((error) {
        //Error, show something
      });
    }).catchError((err) {});
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
  }
}
