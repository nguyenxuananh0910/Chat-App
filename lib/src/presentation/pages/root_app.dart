import 'package:chatappdemo/src/presentation/account/profile_page_view.dart';
import 'package:chatappdemo/src/presentation/groupchat/group_page_view.dart';
import 'package:chatappdemo/src/presentation/mess/listmessage/listmessage_page_view.dart';
import 'package:chatappdemo/src/presentation/contact/contact_page_view.dart';
import 'package:chatappdemo/theme/colors.dart';
import 'package:chatappdemo/utils/root_app_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootApp extends StatefulWidget {
  static const routerName = '/RootApp';
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: getTabs(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        ListMessagePageView(),
        GroupchatView(),
        ContactsPageView(),
        ProfilePageView(),
        // ProfilePage(),
      ],
    );
  }

  Widget getTabs() {
    return SalomonBottomBar(
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        items: List.generate(rootAppJson.length, (index) {
          return SalomonBottomBarItem(
              selectedColor: rootAppJson[index]['color'],
              icon: SvgPicture.asset(
                rootAppJson[index]['icon'],
                color: rootAppJson[index]['color'],
              ),
              title: Text(rootAppJson[index]['text']));
        }));
  }
}
