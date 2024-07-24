import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/login_bloc.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<LoginBloc>();
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
                    onChanged: (phone) {
                      bloc.onChangePhone(phone);
                    },
                    labelText: "Enter Your Phone Number",
                  ),

                  const SizedBox(
                    height: kMarginMedium3,
                  ),

                  CustomTextFieldWidget(
                    onChanged: (email) {
                      bloc.onEmailChanged(email);
                    },
                    labelText: "Enter Your Email",
                  ),

                  const SizedBox(
                    height: kMarginMedium3,
                  ),

                  CustomTextFieldWidget(
                    onChanged: (password) {
                      bloc.onPasswordChanged(password);
                    },
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
                        bloc
                            .onTapLogin()
                            .then((value) => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false))
                            .catchError((error) {
                          showErrorSnackBarWithMessage(
                              context, error.toString());
                        });
                      },
                      label: "Login",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
    this.onTap,
    required this.label,
    this.padding,
    this.size,
    this.backgroundColor,
    this.labelColor,
  });

  final void Function()? onTap;
  final String label;
  final EdgeInsets? padding;
  final Size? size;
  final Color? backgroundColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 0),
        maximumSize: size ?? const Size(150, kMargin50),
        padding: padding ??
            const EdgeInsets.symmetric(
                horizontal: kMargin45, vertical: kMargin15),
        backgroundColor: backgroundColor ?? kPrimaryColor,
        foregroundColor: labelColor ?? Colors.white,
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
    this.inputType, this.isAutoFocus,
  });

  final String labelText;
  final bool? isPasswordField;
  final void Function(String) onChanged;
  final TextInputType? inputType;
  final bool? isAutoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: inputType,
      obscureText: isPasswordField ?? false,
      autofocus: isAutoFocus ?? false,
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
