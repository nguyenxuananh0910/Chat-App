import 'package:chatappdemo/src/view/account/updateprofile.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/database.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.qr_code),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
        title: const CustomText(
          text: 'Profile',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(context),
    );
  }
}

Widget getBody(BuildContext context) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('users').doc(user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snapshot
                                    .data?['photoURL'] ==
                                ""
                            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLhlPE0gXGOoAq3qU3GHKSS2Ih3VQDLzZ6GQ&usqp=CAU"
                            : snapshot.data?['photoURL']),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: snapshot.data?['name'],
                            textSize: 25,
                            textColor: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            text: user.email!,
                            textSize: 25,
                            textColor: AppColor.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )
                    ],
                  );
                }
                return Container();
              }),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SizedBox(
                    width: 400,
                    height: 50,
                    child: CustomButton(
                      color: Colors.grey[100]!,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Provider<Database>(
                                      /// provider database and save new msg token (device token) to storage
                                      create: (_) =>
                                          FireStoreDatabase(uid: user.uid),
                                      // ..addMsgToken(token: currentDeviceMsgToken),
                                      child: const account(),
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          CustomText(
                            text: 'account',
                            textSize: 15,
                            textColor: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            width: 200,
            height: 45,
            child: CustomButton(
              color: Colors.red,
              onPressed: _logout,
              child: CustomText(
                text: 'Logout',
                textSize: 15,
                textColor: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _logout() {
  FirebaseAuth.instance.signOut();
}
