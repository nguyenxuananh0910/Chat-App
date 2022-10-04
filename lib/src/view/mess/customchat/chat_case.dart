import 'package:chatappdemo/src/view/mess/customchat/video_ui.dart';
import 'package:flutter/material.dart';

import '../../../../utils/kind_of_file.dart';
import '../../../domain/message.dart';

import 'file.dart';
import 'image.dart';
import 'message_ui.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
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
    switch (message.type) {
      case messageType:
        return MessageBubble(message: message, isMe: isMe);
      case imageType:
        return ImageBubble(message: message, isMe: isMe);
      case videoType:
        return VideoBubble(message: message, isMe: isMe);
      case fileType:
        return FileBubble(
            message: message, isMe: isMe, downloadFile: downloadFile);
      default:
        return const SizedBox.shrink();
    }
  }
}
