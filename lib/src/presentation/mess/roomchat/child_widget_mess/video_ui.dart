import 'package:chatappdemo/core/components/custom_text.dart';
import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/get_color.dart';
import 'package:chatappdemo/utils/time_format.dart';
import 'package:flutter/material.dart';
import 'video_player.dart';

class VideoBubble extends StatelessWidget {
  const VideoBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: (message.sendby != null
            ? MainAxisAlignment.end
            : MainAxisAlignment.start),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 350,
            child: VideoPlayer(videoUrl: message.message!),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: (message.sendby != null
                ? MainAxisAlignment.end
                : MainAxisAlignment.start),
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: dayFormat(message.time!),
                textSize: 15,
                fontWeight: FontWeight.w300,
                textColor: message.sendby != null
                    ? AppColor.black
                    : getSuitableColor(AppColor.black, AppColor.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
