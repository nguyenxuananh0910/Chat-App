import 'package:chatappdemo/src/view/login/login_ui.dart';
import 'package:chatappdemo/src/view/groupchat/group_ui.dart';
import 'package:chatappdemo/src/view/pages/root_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/database.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      // orientation: Orientation.portrait,
    );
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;
        if (user == null) {
          return LoginPage(auth: auth);
        } else {
          return Provider<Database>(
            /// provider database and save new msg token (device token) to storage
            create: (_) => FireStoreDatabase(uid: user.uid),
            // ..addMsgToken(token: currentDeviceMsgToken),
            child: const RootApp(),
          );
        }
      },
    );
  }
}
