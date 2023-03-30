//Libary
import 'dart:async';
import 'package:chatappdemo/configs/global_binding.dart';
import 'package:chatappdemo/configs/router_configs.dart';
import 'package:chatappdemo/src/presentation/splash/landing_page.dart';
import 'package:chatappdemo/utils/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import Files

RemoteMessage? initMsg;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    LocalNotificationService.initialize();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initMsg = await FirebaseMessaging.instance.getInitialMessage();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(const MyApp());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   setStatus("online");
  //   FirebaseMessaging.instance.getInitialMessage();
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (kDebugMode) {
  //       print(" WW = ${message.notification!.title}");
  //     }
  //     if (kDebugMode) {
  //       print(" WW = ${message.notification!.body}");
  //     }
  //     LocalNotificationService.display(message);
  //   });
  //   LocalNotificationService.streToken();
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //
  //   // TODO: implement dispose
  //   super.dispose();
  // }
  //
  // void setStatus(String status) async {
  //   await _firestore
  //       .collection("users")
  //       .doc(_auth.currentUser?.uid)
  //       .update({"status": status});
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // TODO: Handle this case.
  //       setStatus("online");
  //       break;
  //     case AppLifecycleState.inactive:
  //       // TODO: Handle this case.
  //       setStatus("offline");
  //       break;
  //     case AppLifecycleState.paused:
  //       // TODO: Handle this case.
  //       setStatus("offline");
  //       break;
  //     default:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VietInfo Daohp',
      enableLog: false,
      debugShowCheckedModeBanner: false,
      initialRoute: LoadingPage.routerName,
      getPages: RouterConfigs.routes,
      initialBinding: GlobalBinding(),
    );
  }
}
