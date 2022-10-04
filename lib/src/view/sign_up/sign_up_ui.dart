import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../theme/colors.dart';
import 'sign_up_bloc.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text.dart';
import '../../../services/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpBloc bloc;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      final isComplete = await bloc.createUserWithEmailAndPassword(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (isComplete && mounted) Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = SignUpBloc(auth: widget.auth);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildFullNameTextField(),
                          const SizedBox(height: 30),
                          _buildEmailTextField(),
                          const SizedBox(height: 30),
                          _buildPasswordTextField(),
                          const SizedBox(height: 25),
                          _buildSignUpBtn(),
                          const SizedBox(height: 25),
                          _buildLoginBtn(),
                          if (snapshot.data == true)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFullNameTextField() {
    return StreamBuilder<String?>(
      stream: bloc.fullNameStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _nameController,
          decoration: InputDecoration(
            icon: const Icon(Icons.assignment_ind, color: AppColor.black),
            labelText: 'FullName',
            labelStyle: const TextStyle(color: AppColor.black),
            errorText: snapshot.data,
          ),
          cursorColor: AppColor.black,
          style: const TextStyle(color: AppColor.black),
          autocorrect: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  Widget _buildEmailTextField() {
    return StreamBuilder<String?>(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _emailController,
          decoration: InputDecoration(
            icon: const Icon(Icons.email, color: AppColor.black),
            labelText: 'Email',
            labelStyle: const TextStyle(color: AppColor.black),
            hintText: 'example@example.com',
            hintStyle: TextStyle(color: AppColor.black.withOpacity(0.5)),
            errorText: snapshot.data,
          ),
          cursorColor: AppColor.black,
          style: const TextStyle(color: AppColor.black),
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  Widget _buildPasswordTextField() {
    return StreamBuilder<String?>(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock, color: AppColor.black),
            labelText: 'Password',
            labelStyle: const TextStyle(color: AppColor.black),
            errorText: snapshot.data,
          ),
          cursorColor: AppColor.black,
          style: const TextStyle(color: AppColor.black),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: _createUserWithEmailAndPassword,
        );
      },
    );
  }

  Widget _buildSignUpBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: Colors.blue,
        borderRadius: 20,
        onPressed: _createUserWithEmailAndPassword,
        child: const CustomText(
          text: 'SIGN UP',
          textSize: 18,
          textColor: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Already  have an account ?",
          textSize: 16,
          textColor: AppColor.black,
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
