import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/presentation/account/child_widget_account/avatar.dart';
import 'package:chatappdemo/src/presentation/account/child_widget_account/update_profile/update_page_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPageView extends GetView<UpdateProfileController> {
  static const routerName = '/AccountPageView';
  const AccountPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildCameraOverlay() => Icon(
          Icons.camera_alt_outlined,
          size: 40,
          color: AppColor.primary.withOpacity(0.8),
        );
    Widget buildUploadStatus(UploadTask uploadTask) {
      return StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;

            return progress != 1
                ? CircularProgressIndicator(value: progress)
                : buildCameraOverlay();
          } else {
            return buildCameraOverlay();
          }
        },
      );
    }

    Widget buildAvatar() {
      return CupertinoButton(
        onPressed:
            controller.isUploadNewAvatar ? null : controller.onPressChangeImage,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Avatar(avatar: controller.avatar.value),
                ),
                Center(
                  child: controller.task.value != null
                      ? buildUploadStatus(controller.task.value!)
                      : buildCameraOverlay(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildSaveButton() {
      return Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.purpleApp,
              ),
              onPressed: () {
                controller.changePassword(
                    currentPassword: controller.passwordController.text,
                    newPassword: controller.newpass.text);
                final newName = controller.nameController.text.trim();
                var collection = FirebaseFirestore.instance.collection('users');
                collection
                    .doc(controller.authenService.currentUser?.uid)
                    .update({'name': newName});
                Get.back();
              },
              child: const CustomText(
                text: 'Save',
                textSize: 20,
                textColor: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ));
    }

    return KeyboardDismisser(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(children: const [
                    Icon(Icons.arrow_back_ios),
                    Text("Back",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ]),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: const Text("Edit Profile",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: AppColor.purpleApp,
                        ))),
                Center(
                  child: buildAvatar(),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Email :',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.authenService.currentUser!.email!,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: 'Name:',
                            textSize: 16,
                            fontWeight: FontWeight.w500,
                            textColor: getSuitableColor(
                                AppColor.black, AppColor.white),
                          ),
                          const SizedBox(
                            width: 5,
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
                        height: 20,
                      ),
                      TextField(
                        controller: controller.passwordController,
                        obscureText: controller.showPass.value,
                        decoration: InputDecoration(
                            suffix: GestureDetector(
                              onTap: controller.onToggleShowPass,
                              child: Text(
                                  controller.showPass.value ? "HIDE" : "Show",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 15)),
                            filled: true,
                            fillColor: Colors.white60,
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: controller.newpass,
                        obscureText: controller.showPass.value,
                        decoration: InputDecoration(
                            suffix: GestureDetector(
                              onTap: controller.onToggleShowPass,
                              child: Text(
                                  controller.showPass.value ? "HIDE" : "Show",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 15)),
                            filled: true,
                            fillColor: Colors.white60,
                            labelText: 'New Password',
                            prefixIcon: const Icon(Icons.lock)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
