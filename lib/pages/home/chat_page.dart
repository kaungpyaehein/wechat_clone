import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/utils/images.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: buildDefaultAppBar(
        context: context,
        title: "Chats",
        iconPath: kSearchIcon,
        onTap: (){}
      ),
    );
  }
}
