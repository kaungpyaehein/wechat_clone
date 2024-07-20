import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/chat_page.dart';
import 'package:wechat_clone/pages/home/contacts_page.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/pages/home/profile_page.dart';
import 'package:wechat_clone/pages/home/settings_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    const MomentPage(),
    const ChatPage(),
    const ContactsPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        height: kMarginXXLarge2,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x3F454545),
              blurRadius: 20,
              offset: Offset(0, -4),
              spreadRadius: 0,
            )
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kGreyTextColor,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(
              color: kPrimaryColor,
              fontFamily: kYorkieDemo,
              fontWeight: FontWeight.w700,
              fontSize: kTextSmall),
          unselectedLabelStyle: const TextStyle(
              color: kGreyTextColor,
              fontFamily: kYorkieDemo,
              fontWeight: FontWeight.w700,
              fontSize: kTextSmall),
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kMomentIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kMomentIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                    color: kPrimaryColor,
                  ),
                ),
                label: "Moment"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kChatIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kChatIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                    color: kPrimaryColor,
                  ),
                ),
                label: "Chat"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kContactsIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kContactsIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                    color: kPrimaryColor,
                  ),
                ),
                label: "Contacts"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kProfileIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kProfileIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                    color: kPrimaryColor,
                  ),
                ),
                label: "Me"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kMenuIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: kMarginSmall),
                  child: Image.asset(
                    kMenuIcon,
                    height: kBottomNavIconSize,
                    width: kBottomNavIconSize,
                    color: kPrimaryColor,
                  ),
                ),
                label: "Settings"),
          ],
        ),
      ),
    );
  }
}
