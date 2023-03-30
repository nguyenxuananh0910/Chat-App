import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/components/customappbar.dart';
import 'package:chatappdemo/src/presentation/contact/contact_page_ctrl.dart';
import 'package:chatappdemo/src/presentation/mess/listmessage/child_widget_mess/search.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_view.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsPageView extends GetView<ContactController> {
  static const String routerName = '/Contacts';
  const ContactsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
        title: const CustomText(
          text: 'Contacts',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    return Obx(() {
      return ListView.builder(
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final searchUser = controller.users[index];
          if (searchUser.idUsers != controller.user!.uid) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                onTap: () {
                  Get.toNamed(ChatAppPageView.routerName, arguments: {
                    'groupchatId': null,
                    'listMenber': [searchUser.idUsers],
                  });
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => ChatAppPageView(
                  //           groupchatId: null,
                  //           listMenber: [searchUser.idUsers],
                  //         )));
                },
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(searchUser.urlAvatar == ""
                      ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                      : searchUser.urlAvatar!),
                ),
                title: CustomText(
                  text: (searchUser.name!),
                  textColor: AppColor.black,
                  textSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                subtitle: CustomText(
                  text: (searchUser.status!),
                  textColor: AppColor.black,
                  textSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                trailing: const Icon(
                  Icons.message,
                  color: AppColor.loyalBlue,
                ),
              ),
            );
          }
          return Container();
        },
      );
    });

    //
    // else {
    //   return const Center(
    //       child: CustomText(
    //     text: 'No user',
    //     textColor: AppColor.black,
    //     textSize: 20,
    //     fontWeight: FontWeight.w500,
    //   ));
    // }
    // },
  }
}
