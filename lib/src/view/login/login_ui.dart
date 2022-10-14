import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../theme/colors.dart';
import 'login_bloc.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text.dart';

import '../../../services/auth.dart';
import '../sign_up/sign_up_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc bloc;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await bloc.signInWithEmail(
          _emailController.text, _passwordController.text);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  void _signUp() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SignUpPage(auth: widget.auth),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) =>
            SlideTransition(
                position: animation.drive(Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.linear))),
                child: child),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LoginBloc(auth: widget.auth);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
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
              padding: const EdgeInsets.only(top: 25),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
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
                      if (snapshot.data == true)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            _buildEmailTextField(),
                            const SizedBox(height: 20),
                            _buildPasswordTextField(),
                            const SizedBox(height: 30),
                            _buildLoginBtn(),
                            const SizedBox(height: 15),
                            const CustomText(
                              text: 'Or',
                              textColor: AppColor.black,
                              textSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 15),
                            _buildLoginGooleBtn(),
                            const SizedBox(height: 20),
                            _buildSignUpBtn(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return StreamBuilder<String?>(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _emailController,
          decoration: InputDecoration(
            icon: const Icon(Icons.email, color: AppColor.doveGray),
            labelText: 'Email',
            labelStyle: const TextStyle(color: AppColor.doveGray),
            hintText: 'example@example.com',
            hintStyle: TextStyle(color: AppColor.white.withOpacity(0.5)),
            errorText: snapshot.data,
          ),
          cursorColor: AppColor.white,
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
            icon: const Icon(Icons.lock, color: AppColor.doveGray),
            labelText: 'Password',
            labelStyle: const TextStyle(color: AppColor.doveGray),
            errorText: snapshot.data,
          ),
          style: const TextStyle(color: AppColor.black),
          cursorColor: AppColor.white,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: _signInWithEmail,
        );
      },
    );
  }

  Widget _buildLoginBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: AppColor.loyalBlue,
        borderRadius: 25,
        onPressed: _signInWithEmail,
        child: CustomText(
          text: 'LOGIN',
          textSize: 18.sp,
          textColor: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginGooleBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
          color: AppColor.white,
          borderRadius: 25,
          onPressed: _signInWithEmail,
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

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Don't have an account? ",
          textSize: 16,
          textColor: AppColor.doveGray,
        ),
        GestureDetector(
          onTap: _signUp,
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
