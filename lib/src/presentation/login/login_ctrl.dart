import 'dart:async';

import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/infrastructure/repositories/authen_repo.dart';
import 'package:chatappdemo/src/presentation/signup/signup_page_view.dart';
import 'package:chatappdemo/theme/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../pages/root_app.dart';

class LoginController extends GetxController {
  AuthenService authenService = AuthenRepo();
  final _firebaseAuth = FirebaseAuth.instance;
  // late final AuthenService auth;
  //
  // final StreamController<bool> isLoadingController = StreamController<bool>();
  // final emailController = BehaviorSubject<String?>();
  // final passwordController = BehaviorSubject<String?>();
  //
  // Stream<bool> get isLoadingStream => isLoadingController.stream;
  //
  // Stream<String?> get emailStream => emailController.stream;
  //
  // Stream<String?> get passwordStream => passwordController.stream;

  // void setIsLoading(bool isLoading) => isLoadingController.sink.add(isLoading);
  final RxBool isLoading = false.obs;
  final key = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController forgetEmail = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<User?> signIn(Future<User?> signInMethod) async {
    try {
      isLoading.value = true;
      final user = await signInMethod;
      if (user != null) {
        Get.offAllNamed(RootApp.routerName);
      }
      return user;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> checksignInWithEmail(String email, String password) async {
    if (key.currentState!.validate()) {
      return signIn(authenService.signInWithEmail(email, password));
    }
    return null;
  }

  Future<void> signInWithEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await checksignInWithEmail(
        email.text,
        password.text,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  void forgetPassWord(String email) {
    _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar("Email sent", "We have sent password reset email");
    }).catchError((e) {
      print("Error in sending password reset email  is $e");
    });
  }

  void signUp() {
    Get.toNamed(SignUpPageView.routerName);
  }
}
