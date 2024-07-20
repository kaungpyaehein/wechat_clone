import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/utils/images.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
          context: context,
          title: "Contacts",
          iconPath: kAddContactIcon,
          onTap: () {}),
    );
  }
}
