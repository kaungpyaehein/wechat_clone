import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/login_bloc.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/widgets/custom_back_button.dart';
import 'package:wechat_clone/widgets/custom_text_field_widget.dart';
import 'package:wechat_clone/widgets/loading_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<LoginBloc>();
        return Selector<LoginBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) {
            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: const CustomBackButton(),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kMarginXLarge2),
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
                            inputType: TextInputType.phone,
                            maxLength: 11,
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
                                    .then((value) =>
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (
                                              context) => const HomePage(),
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
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black12,
                    child: const Center(
                      child: LoadingView(),
                    ),
                  ),
                )
              ],
            );
          },
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



