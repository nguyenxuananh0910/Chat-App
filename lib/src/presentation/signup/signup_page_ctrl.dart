import 'dart:async';

import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:chatappdemo/src/infrastructure/repositories/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SingUpController extends GetxController {
  final AuthenService _authenService = AuthenRepo();
  final RxBool isLoading = false.obs;
  final key = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<bool> checkcreateUserWithEmailAndPassword(
      String name, String email, String password) async {
    if (key.currentState!.validate()) {
      try {
        isLoading(true);
        final user = await _authenService.createUserWithEmailAndPassword(
            email, password);
        await user!.updateDisplayName(name);
        UserRepo().saveUserInfo(
          userInfo: UserInfoModel(
            idUsers: user.uid,
            name: name,
            urlAvatar: user.photoURL ?? '',
            msgToken: [],
            status: 'online',
          ),
        );
        return true;
      } catch (e) {
        isLoading(false);
        rethrow;
      }
    }
    return false;
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final isComplete = await checkcreateUserWithEmailAndPassword(
        name.text,
        email.text,
        password.text,
      );
      if (isComplete) Get.back();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}
