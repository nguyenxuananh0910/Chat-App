import 'package:chatappdemo/src/view/mess/customchat/chat_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/components/custom_text.dart';

import '../../../../theme/colors.dart';
import '../../../../utils/get_color.dart';
import '../../../../utils/time_format.dart';
import '../../../domain/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          (isMe ? MainAxisAlignment.end : MainAxisAlignment.start),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: isMe ? AppColor.primary : Colors.grey[400],
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomText(
                    textSize: 18,
                    text: message.message,
                    textColor: isMe
                        ? AppColor.white
                        : getSuitableColor(AppColor.black, AppColor.white),
                  ),
                ),
              ),
            ),
            CustomText(
              text: dayFormat(message.time),
              textSize: 15,
              fontWeight: FontWeight.w300,
              textColor: isMe
                  ? AppColor.black
                  : getSuitableColor(AppColor.black, AppColor.white),
            )
          ],
        ),
      ],
    );
  }
}
