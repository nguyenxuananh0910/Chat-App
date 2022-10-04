import 'package:chatappdemo/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  const CustomAppBar({Key? key, required this.title, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.loyalBlue,
      elevation: 0.0,
      title: title,
      flexibleSpace: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        ),
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(125);
}
