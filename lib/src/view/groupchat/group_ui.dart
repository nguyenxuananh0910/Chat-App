import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import '../../../theme/colors.dart';
import 'package:chatappdemo/theme/colors.dart';
import '../../../services/auth.dart';
import '../mess/room-chat.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../mess/search.dart';
import 'adduser_ui.dart';
// ignore: depend_on_referenced_packages

class Groupchat extends StatefulWidget {
  const Groupchat({Key? key}) : super(key: key);

  @override
  State<Groupchat> createState() => _GroupchatState();
}

class _GroupchatState extends State<Groupchat> {
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
          text: 'Group',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreateGroup()));
        },
        backgroundColor: AppColor.loyalBlue,
        child: const Icon(Icons.add),
      ),
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
            .where('chatType', isEqualTo: "Group")
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
                          ? "https://png.pngtree.com/png-vector/20191009/ourlarge/pngtree-group-icon-png-image_1796653.jpg"
                          : groupchat['avataUrl']),
                    ),
                    title: StreamBuilder<DocumentSnapshot>(
                        stream: showInfoRecevier(groupchat['menber']),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return CustomText(
                              text: groupchat['groupName'],
                              textSize: 18,
                              textColor: AppColor.black,
                              fontWeight: FontWeight.w500,
                            );
                          }
                          return Container();
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
                          return const SizedBox.shrink();
                        }),
                    onTap: () {
                      // print("${groupchat['menber']}");
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
