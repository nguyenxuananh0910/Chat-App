import 'package:chatappdemo/src/domain/services/authen_service.dart';
import 'package:chatappdemo/src/presentation/login/login_page_view.dart';
import 'package:chatappdemo/src/presentation/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingPage extends StatefulWidget {
  static const routerName = '/LoadingPage';
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });

    super.initState();
  }

  Future init() async {
    final AuthenService authenService = Get.find();
    if (authenService.currentUser != null) {
      Get.offAllNamed(RootApp.routerName);
    } else {
      Get.offAllNamed(LoginPageView.routerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://cdn.pixabay.com/photo/2016/11/30/18/14/chat-1873536_960_720.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
