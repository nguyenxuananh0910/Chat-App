import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import '../../../services/auth.dart';
import 'room-chat.dart';
import 'search.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Mess extends StatefulWidget {
  const Mess({
    Key? key,
  }) : super(key: key);

  @override
  State<Mess> createState() => _MessState();
}

class _MessState extends State<Mess> {
  final currentUser = Auth().currentUser;
  Stream<DocumentSnapshot> showInfoRecevier(List groupchat) {
    String a = '';
    for (var item in groupchat) {
      if (item.toString() != currentUser!.uid) {
        a = item.toString().trim();
      }
    }
    return FirebaseFirestore.instance.collection('users').doc(a).snapshots();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          text: 'Messenger',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: const Icon(Icons.search_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [listChat()],
        ),
      ),
    );
  }

  Widget listChat() {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('group')
            .where('chatType', isEqualTo: "Private")
            .where('menber', arrayContains: _auth.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemBuilder: (context, index) {
              final groupchat = snapshot.data!.docs[index];
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(groupchat['avataUrl'] == ""
                          ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                          : groupchat['avataUrl']),
                    ),
                    title: StreamBuilder<DocumentSnapshot>(
                        key: UniqueKey(),
                        stream: showInfoRecevier(groupchat['menber']),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return CustomText(
                              text: snapshot.data?['name'],
                              textSize: 18,
                              textColor: AppColor.black,
                              fontWeight: FontWeight.w500,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                    subtitle: StreamBuilder<DocumentSnapshot>(
                        key: UniqueKey(),
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(groupchat['lastmessages'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            final lastmess = snapshot.data!;
                            return Row(
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                    key: UniqueKey(),
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(lastmess['sendby'])
                                        .get(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.hasData) {
                                        final usermess = snapshot1.data!;
                                        return CustomText(
                                          text: '${usermess['name']}: ',
                                          textSize: 18,
                                          textColor: AppColor.lightGray,
                                          fontWeight: FontWeight.w400,
                                        );
                                      }
                                      // if (snapshot1.data == null) {
                                      //   return SizedBox.shrink();
                                      // }
                                      return const SizedBox.shrink();
                                    }),
                                CustomText(
                                  text: lastmess['type'] == 1
                                      ? lastmess['message']
                                      : "tep dinh kem &",
                                  textSize: 18,
                                  textColor: AppColor.lightGray,
                                  fontWeight: FontWeight.w400,
                                )
                              ],
                            );
                          }
                          return Container();
                        }),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatApp(
                                    groupchatId: snapshot.data!.docs[index].id,
                                    listMenber: snapshot
                                        .data!.docs[index]['menber']
                                        .toList(),
                                  )));
                    },
                  )
                ],
              );
            },
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
          );
        },
      ),
    );
  }
}
