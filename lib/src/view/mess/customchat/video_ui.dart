import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/components/custom_text.dart';
import 'video_player.dart';

import '../../../../theme/colors.dart';
import '../../../../utils/get_color.dart';
import '../../../../utils/time_format.dart';
import '../../../domain/message.dart';

class VideoBubble extends StatelessWidget {
  const VideoBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment:
            (isMe ? MainAxisAlignment.end : MainAxisAlignment.start),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: VideoWidget(videoUrl: message.message),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment:
                (isMe ? MainAxisAlignment.end : MainAxisAlignment.start),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: dayFormat(message.time),
                textSize: 15,
                fontWeight: FontWeight.w300,
                textColor: isMe
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
