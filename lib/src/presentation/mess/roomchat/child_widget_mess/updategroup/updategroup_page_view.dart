import 'package:chatappdemo/core/components/custom_button.dart';
import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/updategroup/updategroup_page_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'child_widget_updategroup/add_member_page_view.dart';

class UpdateGroupPageView extends GetView<UpdateGroupController> {
  static const String routerName = '/UpdateGroupPageView';
  //
  const UpdateGroupPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Get.offAllNamed(RootApp.routerName);
        //     },
        //     icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("back"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                final groupChat = controller.group.value;
                if (groupChat == null) {
                  return const SizedBox.shrink();
                }
                controller.nameController.text = groupChat.groupName!;
                final List<String> listUser = List.generate(
                    groupChat.menber!.toList().length,
                    (index) => groupChat.menber![index].toString());
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(groupChat
                                    .avataUrl?.isEmpty ??
                                true
                            ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                            : groupChat.avataUrl!),
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
                            controller: controller.nameController,
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
                    if (groupChat.chatType == 'Group')
                      Column(
                        children: [
                          CustomText(
                            text: 'Member',
                            textSize: 16,
                            fontWeight: FontWeight.w500,
                            textColor: getSuitableColor(
                                AppColor.black, AppColor.white),
                          ),
                          ListTile(
                            onTap: () {
                              Get.toNamed(
                                AddMemberGroup.routerName,
                                arguments: {
                                  'groupChatId': groupChat.id,
                                  'listMember': groupChat.menber,
                                },
                              );
                            },
                            leading: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 28,
                            ),
                            title: const CustomText(
                              text: 'Add Member',
                              fontWeight: FontWeight.w500,
                              textSize: 18,
                              textColor: Colors.black,
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
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
                                      final users = UserInfoModel.fromDocument(
                                          snapshot.data!);
                                      return Column(
                                        children: [
                                          ListTile(
                                            onTap: () =>
                                                controller.showDialogBox(index),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(users
                                                          .urlAvatar ==
                                                      ""
                                                  ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                                                  : users.urlAvatar!),
                                            ),
                                            title: CustomText(
                                              text: users.name ?? '',
                                              textSize: 16,
                                              fontWeight: FontWeight.w500,
                                              textColor: getSuitableColor(
                                                  AppColor.black,
                                                  AppColor.white),
                                            ),
                                            trailing: CustomText(
                                              text: users.idUsers ==
                                                      controller.getUserId()
                                                  ? 'Admin'
                                                  : "member",
                                              textSize: 16,
                                              fontWeight: FontWeight.w500,
                                              textColor: getSuitableColor(
                                                  AppColor.black,
                                                  AppColor.white),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            indent: 90,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  });
                            },
                          ),
                        ],
                      )
                  ],
                );
              }),
              const SizedBox(
                height: 15,
              ),
              ListTile(
                onTap: () {
                  controller.onLeaveGroup();
                },
                leading: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.red,
                  size: 35,
                ),
                title: const CustomText(
                  text: 'Leave chat',
                  fontWeight: FontWeight.w900,
                  textSize: 20,
                  textColor: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeNameButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CustomButton(
        color: AppColor.primary,
        onPressed: () {
          controller.changeName();
          Get.back();
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
