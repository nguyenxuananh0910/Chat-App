import 'package:flutter/material.dart';
import '../../../../core/components/custom_text.dart';

import '../../../../theme/colors.dart';
import '../../../../utils/get_color.dart';
import '../../../../utils/time_format.dart';
import '../../../domain/message.dart';
import 'image_viewer.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          (isMe ? MainAxisAlignment.end : MainAxisAlignment.start),
      crossAxisAlignment:
          (isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ImageViewer(url: message.message)));
          },
          child: Hero(
            tag: message.message,
            child: Image.network(
              message.message,
              width: 300,
              height: 400,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment:
              (isMe ? MainAxisAlignment.end : MainAxisAlignment.start),
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
    );
  }
}
