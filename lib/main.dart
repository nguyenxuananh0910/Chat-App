//Libary
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Files
import '../services/auth.dart';
import '../src/landing_page.dart';
import '../theme/app_theme.dart';
import '../theme/strings.dart';

RemoteMessage? initMsg;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initMsg = await FirebaseMessaging.instance.getInitialMessage();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(MyApp());
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("online");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // TODO: implement dispose
    super.dispose();
  }

  void setStatus(String status) async {
    await _firestore
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .update({
          "status": status
        });

    // Check User có trong máy ko
    // var a = await _firestore.collection("users").get();
    // print("${a.docs.map((doc) => doc.data())} - ${_auth.currentUser?.uid}");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        setStatus("online");
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        setStatus("offline");
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        setStatus("offline");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider<Database>(create: (_) => FireStoreDatabase(uid: UserInfo.id)),
        Provider<AuthBase>(create: (_) => Auth()),
        // Provider<NotificationBase>(create: (_) => notification),
      ],
      child: MaterialApp(
        title: Strings.appName,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const LandingPage(),
      ),
    );
  }
}
