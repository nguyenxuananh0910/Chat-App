import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/extension.dart';
import 'package:chatappdemo/src/domain/model/group_model.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/rightcontent.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/showfile.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'child_widget_mess/leftcontent.dart';
import 'child_widget_mess/updategroup/updategroup_page_view.dart';

class ChatAppPageView extends GetView<RoomChatController> {
  static const String routerName = '/ChatAppPageView';
  const ChatAppPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.square(65),
          child: AppBar(
            // leading: IconButton(
            //     onPressed: () {
            //       Get.offAllNamed(RootApp.routerName);
            //     },
            //     icon: const Icon(Icons.arrow_back_ios)),
            title: controller.idGroupChat != null
                ? StreamBuilder<DocumentSnapshot>(
                    key: UniqueKey(),
                    stream: FirebaseFirestore.instance
                        .collection('group')
                        .doc(controller.idGroupChat)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      final groupChat =
                          GroupModel.fromDocumentSnapshot(snapshot.data!);

                      if (groupChat.groupName != "") {
                        return CustomText(
                          text: groupChat.groupName!,
                          textSize: 25,
                          textColor: AppColor.white,
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return infoChat();
                      }
                    },
                  )
                : infoChat(),
            backgroundColor: AppColor.loyalBlue,
            elevation: 0.0,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 10,
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(
                    UpdateGroupPageView.routerName,
                    arguments: {
                      'idChat': controller.idGroupChat,
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(
                child: controller.idGroupChat != null // check group
                    ? Obx(
                        () {
                          return ListView.builder(
                            reverse: true, //dao chieu list
                            itemCount: controller.roomChat.length,
                            itemBuilder: (context, index) {
                              final message = controller.roomChat;
                              MessageModel? lastItem;
                              if (index > 0) lastItem = message[index - 1];
                              MessageModel? currentItem = message[index];

                              MessageModel? nextItem;
                              if ((controller.roomChat.length - 1) > index) {
                                nextItem = message[index + 1];
                              }
                              if (currentItem.sendby !=
                                  controller.authenService.currentUser!.uid) {
                                return LeftContent(
                                  current: currentItem,
                                  last: lastItem,
                                  next: nextItem,
                                  isHienThiGio: (!(lastItem?.time
                                              .checkHourMinute(
                                                  currentItem.time) ??
                                          false)
                                      ? true
                                      : (nextItem!.time.checkHourMinute(
                                              currentItem.time)) &&
                                          lastItem!.sendby ==
                                              controller.authenService
                                                  .currentUser?.uid),
                                );
                              }
                              return RightContent(
                                current: currentItem,
                                last: lastItem,
                                next: nextItem,
                                currentIndex: index,
                              );
                            },
                          );
                        },
                      )
                    : Container()),
            const SizedBox(
              height: kBottomNavigationBarHeight + 30,
            ),
          ],
        ),
        getBottomBar(Get.context)
      ],
    );
  }

  Widget getBottomBar(context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200]!,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => ShowFile()));
              },
              child: const Icon(
                FontAwesomeIcons.image,
                color: AppColor.primary,
                size: 25,
              ),
            ),
            Container(
              width: size.width * 0.69,
              decoration: BoxDecoration(
                  color: AppColor.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: TextField(
                  maxLines: 1,
                  controller: controller.message,
                  onSubmitted: (value) => controller.onSendMessage(type: 1),
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    color: AppColor.black,
                  ),
                  cursorColor: AppColor.primary,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () => controller.onSendMessage(type: 1),
                child: const Icon(
                  Icons.send,
                  color: AppColor.primary,
                  size: 28,
                )),
          ],
        ),
      ),
    );
  }

  Widget infoChat() {
    return StreamBuilder<DocumentSnapshot>(
      key: UniqueKey(),
      stream: controller.showInfoRecevier(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          controller.userTemple = snapshot.data!; // lay thong tin user

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: controller.userTemple?['name'],
                textSize: 25,
                textColor: AppColor.white,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: controller.userTemple?['status'],
                textSize: 12,
                textColor: AppColor.white,
                fontWeight: FontWeight.w500,
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
