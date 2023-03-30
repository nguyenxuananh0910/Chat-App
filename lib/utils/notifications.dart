import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static String serverkey =
      'AAAA99lO9uw:APA91bEg9cqwefdscwGzbVnnjT_aI08NEtvcMVcExJoZpqZ984tBFfrNg-jf7FGEksNGzF4v-Hmm8Vtk8ObVqKIcTEAJsWtwKHU0zst-yy78owXlgXwT52YDRyH6Tr2N53HmgSAnJgFk';

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: DarwinInitializationSettings(),
            android: AndroidInitializationSettings('mipmap/ic_launcher'));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("in Notidicaton method");
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "com.example.chatappdemo",
        "com.example.chatappdemo",
        importance: Importance.max,
        priority: Priority.high,
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    } on Exception catch (e) {
      print("Error>>$e");
    }
  }

  static Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    print("token is $token");

    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "message": message,
    };

    try {
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverkey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "$token"
          },
        ),
      );

      print(r.body);
      if (r.statusCode == 200) {
        print('DOne');
      } else {
        print(r.statusCode);
      }
    } catch (e) {
      print('exception $e');
    }
  }

  static streToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print(token);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'msgToken': token!}, SetOptions(merge: true));
    } catch (e) {
      print("Error is $e");
    }
  }
}
