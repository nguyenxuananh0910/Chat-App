import 'package:chatappdemo/core/components/custom_button.dart';
import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/extension.dart';
import 'package:chatappdemo/src/presentation/login/login_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/theme/strings.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPageView extends GetView<LoginController> {
  static const String routerName = '/LoginPageView';
  const LoginPageView({
    Key? key,
  }) : super(key: key);
  // final AuthenService auth;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(body: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(top: 25),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CustomText(
                    text: 'Lets Sign you in',
                    textColor: AppColor.loyalBlue,
                    textSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomText(
                    text: 'Welcome Back,',
                    textColor: AppColor.black,
                    textSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                  const CustomText(
                    text: 'You have been missed',
                    textColor: AppColor.black,
                    textSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                  if (controller.isLoading.value)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Form(
                        key: controller.key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            buildEmailTextField(),
                            const SizedBox(height: 20),
                            buildPasswordTextField(),
                            const SizedBox(height: 30),
                            buildForPass(),
                            const SizedBox(height: 20),
                            buildLoginBtn(),
                            const SizedBox(height: 15),
                            const CustomText(
                              text: 'Or',
                              textColor: AppColor.black,
                              textSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 15),
                            buildLoginGooleBtn(),
                            const SizedBox(height: 20),
                            buildSignUpBtn(),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      })),
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: controller.email,
      decoration: InputDecoration(
        icon: const Icon(Icons.email, color: AppColor.doveGray),
        labelText: 'Email',
        labelStyle: const TextStyle(color: AppColor.doveGray),
        hintText: 'example@example.com',
        hintStyle: TextStyle(color: AppColor.white.withOpacity(0.5)),
        // errorText: snapshot.data,
      ),
      cursorColor: AppColor.white,
      style: const TextStyle(color: AppColor.black),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => value.checkEmpty(Strings.emailNullError),
    );
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      controller: controller.password,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock, color: AppColor.doveGray),
        labelText: 'Password',
        labelStyle: TextStyle(color: AppColor.doveGray),
        // errorText: ,
      ),
      style: const TextStyle(color: AppColor.black),
      cursorColor: AppColor.white,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) => value.checkEmpty(Strings.passNullError),
      onEditingComplete: controller.signInWithEmail,
    );
  }

  Widget buildForPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Get.defaultDialog(
                title: 'Forget PassWord?',
                content: Column(
                  children: [
                    TextField(
                      controller: controller.forgetEmail,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email, color: AppColor.doveGray),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: AppColor.doveGray),
                        hintText: 'example@example.com',
                        hintStyle:
                            TextStyle(color: AppColor.white.withOpacity(0.5)),
                      ),
                      cursorColor: AppColor.white,
                      style: const TextStyle(color: AppColor.black),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        controller
                            .forgetPassWord(controller.forgetEmail.text.trim());
                      },
                      color: Colors.blue,
                      minWidth: double.infinity,
                      child: const Text("Sent"),
                    )
                  ],
                ));
          },
          child: const CustomText(
              text: 'Forgot password?',
              textSize: 15,
              textColor: AppColor.black,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildLoginBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: AppColor.loyalBlue,
        borderRadius: 25,
        onPressed: controller.signInWithEmail,
        child: const CustomText(
          text: 'LOGIN',
          textSize: 18,
          textColor: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildLoginGooleBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
          color: AppColor.white,
          borderRadius: 25,

          /// todo login
          onPressed: () {},
          // controller.signInWithEmail,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: 'LOGIN WITH GOOGLE',
                textSize: 18,
                textColor: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ],
          )),
    );
  }

  Widget buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Don't have an account? ",
          textSize: 16,
          textColor: AppColor.doveGray,
        ),
        GestureDetector(
          onTap: controller.signUp,
          child: const CustomText(
            text: "Sign Up",
            textSize: 16,
            fontWeight: FontWeight.bold,
            textColor: AppColor.black,
          ),
        ),
      ],
    );
  }
}
