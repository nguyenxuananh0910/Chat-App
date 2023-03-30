import 'package:chatappdemo/src/presentation/mess/roomchat/roomchat_page_ctrl.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowFile extends StatelessWidget {
  final RoomChatController roomChatController = Get.find<RoomChatController>();
  ShowFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      roomChatController.selectFile();
                    },
                    child: Row(children: [
                      const Icon(
                        Icons.photo_library,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("Gallery",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      roomChatController.getCameraImages();
                    },
                    child: Row(children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("Camera",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
              ],
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Row(children: [
                      const Icon(
                        Icons.attach_file_sharp,
                        size: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text("File",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColor.black,
                                fontWeight: FontWeight.w400,
                              )))
                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
