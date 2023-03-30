import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:flutter/material.dart';
import 'image_viewer.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ImageViewer(url: message.message!)));
          },
          child: Hero(
            tag: message.message!,
            child: Image.network(
              message.message!,
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
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   // mainAxisAlignment: (message.sendby != null
        //   //     ? MainAxisAlignment.end
        //   //     : MainAxisAlignment.start),
        //   children: [
        //     // CustomText(
        //     //   text: dayFormat(message.time!),
        //     //   textSize: 15,
        //     //   fontWeight: FontWeight.w300,
        //     //   textColor: message.sendby != null
        //     //       ? AppColor.black
        //     //       : getSuitableColor(AppColor.black, AppColor.white),
        //     // )
        //   ],
        // )
      ],
    );
  }
}
