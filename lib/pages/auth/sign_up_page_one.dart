import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/regiser_bloc.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/auth/sign_up_page_two.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class SignupPageOne extends StatelessWidget {
  const SignupPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBlocOne(),
      child: Selector<RegisterBlocOne, String>(
        selector: (context, bloc) => bloc.otp,
        builder: (context, otp, child) {
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

                    /// PHONE INPUT VIEW
                    PhoneNumberInputView(),

                    const SizedBox(
                      height: kMarginXXLarge,
                    ),

                    /// PIN PUT VIEW
                    Center(
                      child: CustomPinPutWidget(
                        onChanged: (otp) {
                          final bloc = context.read<RegisterBlocOne>();
                          bloc.onChangeOTP(otp);
                        },
                      ),
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

                    /// VERIFY BUTTON VIEW
                    const Center(child: VerifyButtonView())
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PhoneNumberInputView extends StatelessWidget {
  const PhoneNumberInputView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextFieldWidget(
              inputType: TextInputType.phone,
              labelText: "Enter Your Phone Number",
              onChanged: (text) {
                final bloc = context.read<RegisterBlocOne>();

                bloc.onChangePhoneNumber(text);
              }),
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
    );
  }
}

class VerifyButtonView extends StatelessWidget {
  const VerifyButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<RegisterBlocOne, String>(
      selector: (context, bloc) => bloc.phone,
      builder: (context, phone, _) {
        return PrimaryButtonWidget(
            onTap: () {
              final bloc = context.read<RegisterBlocOne>();
              if (bloc.checkOTP()) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPageTwo(
                        phoneNumber: phone,
                      ),
                    ));
              } else {
                showErrorSnackBarWithMessage(
                    context, "Please check OTP and phone number.");
              }
            },
            label: "Verify");
      },
    );
  }
}

class CustomPinPutWidget extends StatelessWidget {
  const CustomPinPutWidget({
    super.key,
    required this.onChanged,
  });

  final void Function(String) onChanged;

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
      onChanged: onChanged,
      separatorBuilder: (index) => const SizedBox(
        width: kMarginMedium4,
      ),
      defaultPinTheme: defaultPinTheme,
      validator: (s) {
        return null;
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => print(pin),
    );
  }
}
