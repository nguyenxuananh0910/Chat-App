import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/components/custom_button.dart';
import '../../../core/components/custom_text.dart';
import '../../../services/auth.dart';
import '../../../theme/colors.dart';
import '../../../utils/get_color.dart';

class UpDateGroup extends StatefulWidget {
  final String? Idchat;
  const UpDateGroup({Key? key, this.Idchat}) : super(key: key);

  @override
  State<UpDateGroup> createState() => _UpDateGroupState();
}

class _UpDateGroupState extends State<UpDateGroup> {
  final TextEditingController _nameController = TextEditingController();
  String? idGroupChat;
  void initState() {
    idGroupChat = widget.Idchat;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("back"),
      ),
      body: Getbody(),
    );
  }

  Widget Getbody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            key: UniqueKey(),
            stream: FirebaseFirestore.instance
                .collection('group')
                .doc(idGroupChat)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              final groupchat = snapshot.data!;
              _nameController.text = groupchat['groupName'];
              final List<String> listUser = List.generate(
                  groupchat['menber'].toList().length,
                  (index) => groupchat['menber'][index].toString());
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(groupchat['avataUrl'] == ""
                          ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                          : groupchat['avataUrl']),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: 'Group Name:',
                        textSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor:
                            getSuitableColor(AppColor.black, AppColor.white),
                      ),
                      Flexible(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                          ),
                          // onChanged: (value) => setState(() {}),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  _buildChangeNameButton(),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomText(
                    text: 'Menber',
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: getSuitableColor(AppColor.black, AppColor.white),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listUser.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                          key: UniqueKey(),
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(listUser[index])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userID = snapshot.data!;
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(userID[
                                                'photoURL'] ==
                                            ""
                                        ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                                        : userID['photoURL']),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CustomText(
                                    text: userID['name'],
                                    textSize: 16,
                                    fontWeight: FontWeight.w500,
                                    textColor: getSuitableColor(
                                        AppColor.black, AppColor.white),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          });
                    },
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _changeName() {
    FocusManager.instance.primaryFocus?.unfocus();
    final newName = _nameController.text.trim();
    var collection = FirebaseFirestore.instance.collection('group');
    collection.doc(idGroupChat).update({'groupName': newName});
  }

  Widget _buildChangeNameButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: AppColor.primary,
        onPressed: () {
          _changeName();
          Navigator.pop(context);
        },
        child: const CustomText(
          text: 'Change Name',
          textSize: 15,
          textColor: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
