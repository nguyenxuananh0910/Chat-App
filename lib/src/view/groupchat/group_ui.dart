import 'package:flutter/material.dart';

import '../../../core/components/custom_text.dart';
import '../../../core/components/customappbar.dart';
import '../../../theme/colors.dart';
import '../mess/seach.dart';

class Groupchat extends StatefulWidget {
  const Groupchat({Key? key}) : super(key: key);

  @override
  State<Groupchat> createState() => _GroupchatState();
}

class _GroupchatState extends State<Groupchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.qr_code),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          )
        ],
        title: const CustomText(
          text: 'Groups',
          textColor: AppColor.white,
          textSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: getBody(),
    );
  }
}

Widget getBody() {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [],
      ),
    ),
  );
}
