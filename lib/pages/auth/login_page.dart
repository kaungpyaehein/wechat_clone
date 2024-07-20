import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginXLarge2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kMarginLarge,
              ),

              /// TITLE TEXT VIEW
              const Text(
                "Welcome !",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: kYorkieDemo,
                  fontSize: kText30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: kMargin5,
              ),
              const Text(
                "Login to continue",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: kTextRegular2X,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(
                height: kMarginXLarge,
              ),

              /// IMAGE VIEW
              Image.asset(
                kLoginImage,
              ),

              const SizedBox(
                height: kMarginXLarge,
              ),

              /// LOGIN FORM VIEW
              CustomTextFieldWidget(
                onChanged: (text) {},
                labelText: "Enter Your Phone Number",
              ),

              const SizedBox(
                height: kMarginMedium3,
              ),

              CustomTextFieldWidget(
                onChanged: (text) {},
                labelText: "Enter Your Email",
              ),

              const SizedBox(
                height: kMarginMedium3,
              ),

              CustomTextFieldWidget(
                onChanged: (text) {},
                isPasswordField: true,
                labelText: "Enter Your Password",
              ),

              const SizedBox(
                height: kMarginMedium4,
              ),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: kDefaultTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(
                height: kMarginXLarge,
              ),

              /// LOGIN BUTTON
              /// PRIMARY BUTTON
              Center(
                child: PrimaryButtonWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                  label: "Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    required this.onTap,
    required this.label,
    this.padding,
    this.size,
  });

  final void Function() onTap;
  final String label;
  final EdgeInsets? padding;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        minimumSize: Size(0, 0),
        maximumSize: size ?? const Size(150, kMargin50),
        padding: padding ??
            const EdgeInsets.symmetric(
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
      onPressed: onTap,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: kYorkieDemo,
            fontSize: kTextRegular2X,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.labelText,
    this.isPasswordField,
    required this.onChanged,
  });

  final String labelText;
  final bool? isPasswordField;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onChanged: onChanged,
        obscureText: isPasswordField ?? false,
        style: const TextStyle(
            color: kDefaultTextColor,
            fontSize: kTextRegular2X,
            fontFamily: kYorkieDemo),
        decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kDefaultTextColor, width: 1),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kDefaultTextColor, width: 1),
            ),
            alignLabelWithHint: true,
            labelText: labelText,
            labelStyle:
                const TextStyle(fontSize: kTextSmall, color: kGreyTextColor),
            floatingLabelStyle:
                const TextStyle(fontSize: kTextSmall, color: kGreyTextColor)),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackButton(
      style: ButtonStyle(
          iconSize:
              MaterialStateProperty.resolveWith((states) => kBackArrowIconSize),
          foregroundColor:
              MaterialStateProperty.resolveWith((states) => kPrimaryColor)),
    );
  }
}
