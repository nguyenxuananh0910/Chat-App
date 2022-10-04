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
      padding: EdgeInsets.only(left: isMe ? 50 : 0),
      child: Column(
        children: [
          VideoPlayer(videoUrl: message.message),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: dayFormat(message.time),
                textSize: 10,
                fontWeight: FontWeight.w200,
                textColor: getSuitableColor(AppColor.black, AppColor.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
