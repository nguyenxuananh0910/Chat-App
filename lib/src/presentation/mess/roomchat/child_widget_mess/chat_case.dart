import 'package:chatappdemo/src/domain/model/message.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/message.dart';
import 'package:chatappdemo/src/presentation/mess/roomchat/child_widget_mess/video_ui.dart';
import 'package:chatappdemo/utils/kind_of_file.dart';
import 'package:flutter/material.dart';

import 'file.dart';
import 'image.dart';
import 'rightcontent.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    this.downloadFile,
  }) : super(key: key);
  final MessageModel message;

  final void Function()? downloadFile;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case messageType:
        return TextContent(
          current: message.message,
        );
      case imageType:
        return ImageBubble(message: message);
      case videoType:
        return VideoBubble(
          message: message,
        );
      case fileType:
        return FileBubble(message: message, downloadFile: downloadFile);
      default:
        return const SizedBox.shrink();
    }
  }
}
