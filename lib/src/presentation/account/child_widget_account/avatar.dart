import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  static const routerName = '/Avatar';
  const Avatar({Key? key, required this.avatar}) : super(key: key);
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      clipBehavior: Clip.hardEdge,
      child: avatar.isNotEmpty
          ? Image.network(
              avatar,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
