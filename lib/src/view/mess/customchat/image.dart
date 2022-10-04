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
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 50 : 0,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImageViewer(url: message.message)));
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 0.5, minWidth: 1),
              child: Hero(
                tag: message.message,
                child: Image.network(
                  message.message,
                  fit: BoxFit.cover,
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
          ),
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
