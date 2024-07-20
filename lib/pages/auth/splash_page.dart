import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/auth/sign_up_page_one.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height * 0.30,
            ),

            /// LOGO VIEW
            Image.asset(
              kLogoImage,
              height: 150,
              width: 160,
            ),

            SizedBox(
              height: screenSize.height * 0.30,
            ),

            /// INFO TEXT VIEW
            const Text(
              "Text your friends and share moments",
              style: TextStyle(
                fontFamily: kYorkieDemo,
                fontSize: kText18,
                fontWeight: FontWeight.w600,
                color: kDefaultTextColor,
              ),
            ),
            const SizedBox(
              height: kMargin5,
            ),
            const Text(
              "End-to-end secured messaging app with Social Elements",
              style: TextStyle(
                fontSize: kTextSmall,
                fontWeight: FontWeight.w400,
                color: kDefaultTextColor,
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            /// BUTTONS VIEW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// OUTLINE BUTTON
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMargin45, vertical: kMargin15),
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimaryColor,
                    side: const BorderSide(
                      color: kPrimaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kMargin5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPageOne(),));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: kYorkieDemo,
                      fontSize: kTextRegular2X,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(
                  width: kMarginMedium4,
                ),

                /// PRIMARY BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMargin45, vertical: kMargin15),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: kPrimaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kMargin5),
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage(),));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: kYorkieDemo,
                      fontSize: kTextRegular2X,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
