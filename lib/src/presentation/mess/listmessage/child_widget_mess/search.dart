import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../../core/components/custom_text.dart';
import '../../../../../theme/colors.dart';

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
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection('users')
            .where('name', isEqualTo: query)
            .get(),
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
                      onTap: () async {
                        Get.toNamed(ChatAppPageView.routerName, arguments: {
                          'groupchatId': null,
                          'listMenber': [searchuser.id],
                        });
                      },
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(searchuser['photoURL'] ==
                                ""
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
