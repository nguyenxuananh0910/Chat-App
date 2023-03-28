import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/chat_case.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:chatappdemo/utils/time_format.dart';
import 'package:flutter/material.dart';

class RightContent extends StatelessWidget {
  final MessageModel? last;
  final MessageModel current;
  final MessageModel? next;
  final int currentIndex;

  const RightContent(
      {Key? key,
      required this.current,
      required this.last,
      required this.next,
      required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
              child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: ChatBubble(message: current)),
            ),
            if (currentIndex == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomText(
                    text: dayFormat(current.time!),
                    textSize: 15,
                    fontWeight: FontWeight.w300,
                    textColor: getSuitableColor(AppColor.black, AppColor.white),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
