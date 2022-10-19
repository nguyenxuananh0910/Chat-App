import 'package:flutter/material.dart';

import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import '../../../theme/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mess/room-chat.dart';
import '../mess/search.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
        title: const CustomText(
          text: 'Contacts',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final searchuser = snapshot.data!.docs[index];
              if (searchuser.id != user!.uid) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ChatApp(
                                groupchatId: null,
                                listMenber: [searchuser.id],
                              )));
                    },
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(searchuser['photoURL'] == ""
                          ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                          : searchuser['photoURL']),
                    ),
                    title: CustomText(
                      text: (searchuser["name"]),
                      textColor: AppColor.black,
                      textSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: CustomText(
                      text: (searchuser["status"]),
                      textColor: AppColor.black,
                      textSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    trailing: const Icon(
                      Icons.message,
                      color: AppColor.loyalBlue,
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        } else {
          return const Center(
              child: CustomText(
            text: 'No user',
            textColor: AppColor.black,
            textSize: 20,
            fontWeight: FontWeight.w500,
          ));
        }
      },
    );
  }
}
