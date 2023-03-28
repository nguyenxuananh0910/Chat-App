import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_members_page_ctrl.dart';

class AddMemberGroup extends GetView<AddMemberController> {
  static const routerName = '/AddMemberGroup';
  const AddMemberGroup({Key? key}) : super(key: key);

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
              "Add Member Group",
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
            controller.onAddMember();
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
              width: double.infinity,
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
                    child: Obx(() => ListView.builder(
                          //list 2
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.membersList.length,
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
                                        backgroundImage: NetworkImage(controller
                                                    .membersList[index]
                                                    .photoURL ==
                                                ""
                                            ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                                            : controller
                                                .membersList[index].photoURL),
                                      ),
                                      Positioned(
                                          top: -5,
                                          left: 30,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.removeMembers(index);
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                          )),
                                    ],
                                  ),
                                  CustomText(
                                    text: (controller.membersList[index].name),
                                    textColor: AppColor.black,
                                    textSize: 20,
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                  )
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
    return Obx(() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          var user = controller.users[index];
          if (controller.membersList.contains(
            ListMenber(
              id: user.idUsers!,
              name: user.name!,
              photoURL: user.urlAvatar!,
            ),
          )) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.urlAvatar == ""
                              ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                              : user.urlAvatar!),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: (user.name!),
                              textColor: AppColor.black,
                              textSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: (user.status!),
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
                            controller.addMembers(user);
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
        }));
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

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
