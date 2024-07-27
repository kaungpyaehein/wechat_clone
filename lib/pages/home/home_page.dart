import 'package:flutter/material.dart';
import 'package:wechat_clone/network/data_agents/cloud_firestore_data_agent_impl.dart';
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
  const HomePage({this.selectedIndex = 0, super.key});
  final int selectedIndex;

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
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CloudFirestoreDataAgentImpl().getMoments().first.then((value) {
      print(value[0].comments!.length.toString());
    });

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedFontSize: 0.0,
            unselectedFontSize: 0.0,
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
            elevation: 0,
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
      ),
    );
  }
}
