import 'package:flutter/material.dart';

import 'custom_text.dart';

Future<bool?> customDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String defaultActionText,
    String? cancerActionText}) {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancerActionText != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: CustomText(
              text: cancerActionText,
              textSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: CustomText(
            text: defaultActionText,
            textSize: 18,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}
