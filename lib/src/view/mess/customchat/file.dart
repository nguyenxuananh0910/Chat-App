import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/components/custom_text.dart';

import '../../../../theme/colors.dart';
import '../../../../utils/get_color.dart';
import '../../../../utils/time_format.dart';
import '../../../domain/message.dart';

class FileBubble extends StatelessWidget {
  const FileBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.downloadFile,
  }) : super(key: key);
  final Message message;
  final bool isMe;
  final void Function()? downloadFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: downloadFile,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 50 : 0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColor.primary : AppColor.doveGray.withOpacity(0.3),
          borderRadius: isMe
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
                  color: isMe
                      ? AppColor.white
                      : getSuitableColor(AppColor.black, AppColor.white),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: CustomText(
                    text: message.message,
                    textColor: AppColor.white,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: dayFormat(message.time),
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
