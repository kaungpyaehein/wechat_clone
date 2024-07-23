import 'package:flutter/material.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/auth/splash_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      elevation: 2,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(
        "Settings",
        style: TextStyle(
            color: kPrimaryColor,
            fontSize: 34,
            fontWeight: FontWeight.w600,
            fontFamily: kYorkieDemo),
      ),
      actions: [
        PrimaryButtonWidget(
            padding: const EdgeInsets.all(kMarginMedium),
            size: const Size(kMarginXXLarge3, kMarginXLarge2),
            onTap: ()  {
              AuthModel authModel = AuthModelImpl();
               authModel.logOut().then((_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashPage(),
                  ),
                  (route) => false));
            },
            label: "Log Out"),
        const SizedBox(
          width: kMarginMedium3,
        ),
      ],
    ));
  }
}
