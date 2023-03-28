import 'package:chatappdemo/core/components/custom_button.dart';
import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/extension.dart';
import 'package:chatappdemo/src/presentation/signup/signup_page_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/theme/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUpPageView extends GetView<SingUpController> {
  static const String routerName = '/SignUpPageView';
  const SignUpPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.black,
                      size: 35,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const CustomText(
                  text: 'Lets Register',
                  textColor: AppColor.loyalBlue,
                  textSize: 35,
                  fontWeight: FontWeight.w900,
                ),
                const CustomText(
                  text: 'Account',
                  textColor: AppColor.loyalBlue,
                  textSize: 35,
                  fontWeight: FontWeight.w800,
                ),
                const CustomText(
                  text: 'hello user, you have',
                  textColor: AppColor.black,
                  textSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                const CustomText(
                  text: 'a greatful journey',
                  textColor: AppColor.black,
                  textSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Form(
                    key: controller.key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildFullNameTextField(),
                        const SizedBox(height: 30),
                        buildEmailTextField(),
                        const SizedBox(height: 30),
                        buildPasswordTextField(),
                        const SizedBox(height: 25),
                        buildSignUpBtn(),
                        const SizedBox(height: 25),
                        buildLoginBtn(),
                        if (controller.isLoading.value)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      })),
    );
  }

  Widget buildFullNameTextField() {
    return TextFormField(
      controller: controller.name,
      decoration: const InputDecoration(
        icon: Icon(Icons.assignment_ind, color: AppColor.black),
        labelText: 'FullName',
        labelStyle: TextStyle(color: AppColor.black),
        // errorText: snapshot.data,
      ),
      cursorColor: AppColor.black,
      style: const TextStyle(color: AppColor.black),
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) => value?.checkEmpty(Strings.nameNullError),
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: controller.email,
      decoration: InputDecoration(
        icon: const Icon(Icons.email, color: AppColor.black),
        labelText: 'Email',
        labelStyle: const TextStyle(color: AppColor.black),
        hintText: 'example@example.com',
        hintStyle: TextStyle(color: AppColor.black.withOpacity(0.5)),
        // errorText: snapshot.data,
      ),
      cursorColor: AppColor.black,
      style: const TextStyle(color: AppColor.black),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => value?.checkEmpty(Strings.emailNullError),
    );
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      controller: controller.password,
      decoration: const InputDecoration(
        icon: Icon(Icons.lock, color: AppColor.black),
        labelText: 'Password',
        labelStyle: TextStyle(color: AppColor.black),
        // errorText: snapshot.data,
      ),
      cursorColor: AppColor.black,
      style: const TextStyle(color: AppColor.black),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: controller.createUserWithEmailAndPassword,
      validator: (value) => value?.checkEmpty(Strings.passNullError),
    );
  }

  Widget buildSignUpBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: Colors.blue,
        borderRadius: 20,
        onPressed: controller.createUserWithEmailAndPassword,
        child: const CustomText(
          text: 'SIGN UP',
          textSize: 18,
          textColor: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildLoginBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Already  have an account ?",
          textSize: 16,
          textColor: AppColor.black,
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: const CustomText(
            text: " Login",
            textSize: 16,
            fontWeight: FontWeight.bold,
            textColor: AppColor.black,
          ),
        ),
      ],
    );
  }
}
