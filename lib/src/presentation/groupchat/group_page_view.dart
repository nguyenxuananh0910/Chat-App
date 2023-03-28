import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/components/customappbar.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/domain/model/user.dart';
import 'package:chatappdemo/src/presentation/groupchat/group_ctrl.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_view.dart';
import 'package:chatappdemo/src/presentation/mess/listmessage/child_widget_mess/search.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:chatappdemo/utils/time_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'child_widget_group/adduser_ui.dart';

class GroupchatView extends GetView<GroupController> {
  static const String routerName = '/GroupchatView';
  const GroupchatView({Key? key}) : super(key: key);

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
          Get.toNamed(CreateGroup.routerName);
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
    return SingleChildScrollView(child: Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          final groupChat = controller.group[index];
          return Column(
            children: [
              Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) {}),
                        icon: Icons.delete_forever,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(groupChat.avataUrl == ""
                          ? "https://png.pngtree.com/png-vector/20191009/ourlarge/pngtree-group-icon-png-image_1796653.jpg"
                          : groupChat.avataUrl!),
                    ),
                    title: CustomText(
                      text: groupChat.groupName!,
                      textSize: 18,
                      textColor: AppColor.black,
                      fontWeight: FontWeight.w500,
                    ),
                    subtitle: FutureBuilder<DocumentSnapshot>(
                        key: UniqueKey(),
                        future:
                            controller.updateLastMess(groupChat.lastmessages!),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            final lastMess =
                                MessageModel.fromDocument(snapshot.data!);
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FutureBuilder<DocumentSnapshot>(
                                      future:
                                          controller.showUser(lastMess.sendby!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final userMess =
                                              UserInfoModel.fromDocument(
                                                  snapshot.data!);
                                          return Row(
                                            children: [
                                              CustomText(
                                                text: '${userMess.name!}: ',
                                                textSize: 18,
                                                textColor: AppColor.blackPearl,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              Expanded(
                                                child: CustomText(
                                                  text: lastMess.type == 1
                                                      ? lastMess.message!
                                                      : "tep dinh kem &",
                                                  textSize: 18,
                                                  textColor:
                                                      AppColor.blackPearl,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      }),
                                ),
                                CustomText(
                                  text: dayFormat(lastMess.time!),
                                  textSize: 15,
                                  fontWeight: FontWeight.w300,
                                  textColor: getSuitableColor(
                                      AppColor.black, AppColor.white),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                    onTap: () {
                      Get.toNamed(ChatAppPageView.routerName, arguments: {
                        'groupchatId': groupChat.id,
                        'listMenber': groupChat.menber?.toList(),
                      });
                    },
                  )),
            ],
          );
        },
        itemCount: controller.group.length,
        shrinkWrap: true,
      );
    }));
  }
}
