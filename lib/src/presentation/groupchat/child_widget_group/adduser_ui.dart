import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_view.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CreateGroup extends StatefulWidget {
  static const routerName = '/CreateGroup';
  const CreateGroup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final List<ListMenber> membersList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final users = FirebaseAuth.instance.currentUser;

  void addMembers(DocumentSnapshot? user) {
    setState(() {
      membersList.add(
        ListMenber(
          id: user!.id,
          name: user['name'],
          photoURL: user['photoURL'],
        ),
      );
    });
  }

  void removeMembers(int index) {
    setState(() {
      membersList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.loyalBlue,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Add participants",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.loyalBlue,
          onPressed: () async {
            // tao group nhom

            var listid = List<ListMenber>.generate(
                membersList.length, (index) => membersList[index]);
            Map<String, dynamic> group = {
              "avataUrl": '',
              "chatType": 'Group',
              "lastmessages": "",
              "groupName": [
                ...List.generate(
                    listid.length, (int index) => listid[index].name),
                users!.displayName
              ].join(','),
              "menber": [
                ...List.generate(
                    listid.length, (int index) => listid[index].id),
                users!.uid
              ], // tao 1 list new voi do dai = list cu va item la id
            };
            var idGroupChat =
                (await _firestore.collection('group').add(group)).id;

            Get.toNamed(
              ChatAppPageView.routerName,
              arguments: {
                'groupchatId': idGroupChat,
                'listMenber': membersList,
              },
            );
          },
          child: const Icon(Icons.arrow_forward)),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.group,
                      size: 35,
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          //list 2
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: membersList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(membersList[
                                                        index]
                                                    .photoURL ==
                                                ""
                                            ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                                            : membersList[index].photoURL),
                                      ),
                                      Positioned(
                                          top: -5,
                                          left: 30,
                                          child: GestureDetector(
                                            onTap: () {
                                              removeMembers(index);
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                          )),
                                    ],
                                  ),
                                  CustomText(
                                    text: (membersList[index].name),
                                    textColor: AppColor.black,
                                    textSize: 20,
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                            );
                          }))
                ],
              ),
            ),
            const Divider(
              height: 10,
              thickness: 0.8,
              color: Colors.grey,
            ),
            listUser()
          ],
        ),
      ),
    );
  }

  Widget listUser() {
    //list 1
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              // check user list1 vs list2
              // bool check = false;
              // for (final item in membersList) {
              //   if (user.id == item.id) {
              //     check = true;
              //   }
              // }
              // if (check) {
              //   return const SizedBox.shrink(); // khoang trong
              // }
              if (membersList.contains(
                ListMenber(
                  id: user.id,
                  name: user['name'],
                  photoURL: user['photoURL'],
                ),
              )) {
                return const SizedBox.shrink();
              }
              if (user.id != users?.uid) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(user[
                                            'photoURL'] ==
                                        ""
                                    ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                                    : user['photoURL']),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: (user["name"]),
                                    textColor: AppColor.black,
                                    textSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    text: (user["status"]),
                                    textColor: AppColor.black,
                                    textSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  addMembers(user);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}

class ListMenber {
  final String id;
  final String name;
  final String photoURL;

  ListMenber({
    required this.id,
    required this.name,
    required this.photoURL,
  });

  // so sanh 2 list
  @override
  bool operator ==(Object other) =>
      (identical(this, other) || (other is ListMenber && id == other.id));
}
