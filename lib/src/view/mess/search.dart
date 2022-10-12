import 'package:chatappdemo/src/view/mess/room-chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/components/custom_text.dart';
import '../../../theme/colors.dart';

class SearchUser extends SearchDelegate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('name', isEqualTo: query)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final searchuser = snapshot.data!.docs[index];
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
                  ),
                );
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
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search User'),
    );
  }
}
