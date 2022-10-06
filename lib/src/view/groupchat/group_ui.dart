import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import '../../domain/root_app_json.dart';
import '../../../theme/colors.dart';
import '../mess/room-chat.dart';
import '../mess/seach.dart';

class Groupchat extends StatefulWidget {
  const Groupchat({Key? key}) : super(key: key);

  @override
  State<Groupchat> createState() => _GroupchatState();
}

class _GroupchatState extends State<Groupchat> {
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
          text: 'Groups',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff734DDE),
        child: const Icon(Icons.add_comment),
        onPressed: (){}
      )
    );
  }
}

Widget getBody() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
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
              return Column(
                children: [
                  listGroup(groupchat, context, snapshot, index),
                  listGroup(groupchat, context, snapshot, index),
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

Widget listGroup(groupchat, context, snapshot, index) {
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
      textColor: Color(0xff999CA0),
      textSize: 18,
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatApp(
              groupchatId: snapshot.data!.docs[index].id,
              listMenber: snapshot.data!.docs[index]['menber'].toList(),
            )
        )
      );
    },
  );
}
