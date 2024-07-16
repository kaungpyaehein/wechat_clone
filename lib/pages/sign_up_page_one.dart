import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:wechat_clone/pages/login_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class SignupPageOne extends StatelessWidget {
  const SignupPageOne({super.key});

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
                "Hi !",
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
                "Create a new account",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: kTextRegular2X,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(
                height: kMarginLarge,
              ),

              /// IMAGE VIEW
              Image.asset(
                kSignUpImage,
              ),

              const SizedBox(
                height: kMarginLarge,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextFieldWidget(
                        labelText: "Enter Your Phone Number",
                        onChanged: (text) {}),
                  ),
                  const SizedBox(
                    width: kMarginMedium4,
                  ),
                  SizedBox(
                    width: 100,
                    height: kMargin45,
                    child: PrimaryButtonWidget(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium2, vertical: kMarginMedium2),
                        onTap: () {},
                        label: "Get OTP"),
                  ),
                ],
              ),

              const SizedBox(
                height: kMarginXXLarge,
              ),

              const Center(
                child: CustomPinPutWidget(),
              ),

              const SizedBox(
                height: kMarginXLarge,
              ),

              Center(
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Dont receive the OTP?",
                      style: TextStyle(
                          color: kGreyTextColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: kNotoSans)),
                  TextSpan(
                      text: " Resend Code",
                      style: TextStyle(
                          color: kDefaultTextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: kNotoSans))
                ])),
              ),

              const SizedBox(
                height: kMarginXLarge,
              ),

              Center(child: PrimaryButtonWidget(onTap: () {}, label: "Verify"))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPinPutWidget extends StatelessWidget {
  const CustomPinPutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: kMargin45,
      height: kMargin45,
      textStyle: const TextStyle(
          fontSize: kTextRegular3X,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor),
      decoration: BoxDecoration(
        color: kPinPutBoxColor,
        borderRadius: BorderRadius.circular(kMarginSmall),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFDBDBDB),
            blurRadius: 2,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
    );

    return Pinput(
      separatorBuilder: (index) => const SizedBox(
        width: kMarginMedium4,
      ),
      defaultPinTheme: defaultPinTheme,
      validator: (s) {},
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => print(pin),
    );
  }
}
