import 'package:chatappdemo/core/components/custom_button.dart';
import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/core/components/customappbar.dart';

import 'package:chatappdemo/src/presentation/account/child_widget_account/security.dart';
import 'package:chatappdemo/src/presentation/account/profile_ctrl.dart';
import 'package:chatappdemo/src/presentation/contact/contact_page_view.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'child_widget_account/update_profile/updateprofil_page_view.dart';

class ProfilePageView extends GetView<ProfileController> {
  static const routerName = '/ProfilePageView';
  const ProfilePageView({Key? key}) : super(key: key);

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
          text: 'Profile',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    final users = FirebaseAuth.instance.currentUser;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Obx(() {
              final userMess = controller.user.value;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage((userMess
                                ?.urlAvatar?.isEmpty ??
                            true)
                        ? "https://png.pngtree.com/png-vector/20190805/ourlarge/pngtree-account-avatar-user-abstract-circle-background-flat-color-icon-png-image_1650938.jpg"
                        : userMess!.urlAvatar!),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: userMess?.name ?? '',
                        textSize: 25,
                        textColor: AppColor.black,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: users!.email!,
                        textSize: 20,
                        textColor: AppColor.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  )
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: CustomButton(
                        color: Colors.grey[200]!,
                        onPressed: () {
                          Get.toNamed(AccountPageView.routerName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: AppColor.loyalBlue,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: 'Account',
                                  textSize: 18,
                                  textColor: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: CustomButton(
                        color: Colors.grey[200]!,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.notifications_none,
                                  color: AppColor.loyalBlue,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: 'Notifications',
                                  textSize: 18,
                                  textColor: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: CustomButton(
                        color: Colors.grey[200]!,
                        onPressed: () {
                          Get.toNamed(Security.routerName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.security_outlined,
                                  color: AppColor.loyalBlue,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: 'Security',
                                  textSize: 18,
                                  textColor: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: CustomButton(
                        color: Colors.grey[200]!,
                        onPressed: () {
                          Get.toNamed(ContactsPageView.routerName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: AppColor.loyalBlue,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text: 'Chat',
                                  textSize: 18,
                                  textColor: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SizedBox(
                      width: 400,
                      height: 50,
                      child: CustomButton(
                        color: Colors.grey[200]!,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.help_center_outlined,
                                  color: AppColor.loyalBlue,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text: 'Help',
                                  textSize: 18,
                                  textColor: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200,
              height: 45,
              child: CustomButton(
                color: Colors.red,
                onPressed: controller.logOut,
                child: const CustomText(
                  text: 'Logout',
                  textSize: 15,
                  textColor: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
