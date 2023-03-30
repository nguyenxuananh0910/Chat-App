import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:chatappdemo/utils/time_format.dart';
import 'package:flutter/material.dart';

class FileBubble extends StatelessWidget {
  const FileBubble({
    Key? key,
    required this.message,
    this.downloadFile,
  }) : super(key: key);
  final MessageModel message;

  final void Function()? downloadFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: downloadFile,
      child: Container(
        margin: EdgeInsets.only(
          left: message.sendby != null ? 50 : 0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: message.sendby != null
              ? AppColor.primary
              : AppColor.doveGray.withOpacity(0.3),
          borderRadius: message.sendby != null
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: message.sendby != null
                      ? AppColor.white
                      : getSuitableColor(AppColor.black, AppColor.white),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: CustomText(
                    text: message.message!,
                    textColor: AppColor.white,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: dayFormat(message.time!),
                  textSize: 10,
                  fontWeight: FontWeight.w200,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
