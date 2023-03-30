import 'package:flutter/material.dart';

class TextContent extends StatelessWidget {
  final String? current;

  const TextContent({Key? key, required this.current}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        current!,
        style: const TextStyle(fontSize: 17, color: Colors.white),
      ),
    );
  }
}
