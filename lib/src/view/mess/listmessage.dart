import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import 'room-chat.dart';
import 'seach.dart';

class Mess extends StatefulWidget {
  const Mess({Key? key}) : super(key: key);

  @override
  State<Mess> createState() => _MessState();
}

class _MessState extends State<Mess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          text: 'Chatify',
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          children: [GroupChat()],
        ),
      ),
    );
  }

  Widget GroupChat() {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('group').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');

          return ListView.builder(
            itemBuilder: (context, index) {
              final groupchat = snapshot.data!.docs[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(groupchat["avataUrl"]),
                ),
                title: CustomText(
                  text: (groupchat["groupName"]),
                  textColor: AppColor.black,
                  textSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: const CustomText(
                  text: 'hello',
                  textColor: AppColor.black,
                  textSize: 18,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatApp(
                                groupchatId: snapshot.data!.docs[index].id,
                                listMenber: snapshot.data!.docs[index]['menber']
                                    .toList(),
                              )));
                },
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
