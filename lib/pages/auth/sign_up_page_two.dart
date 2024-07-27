import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/register_bloc_two.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/auth/upload_profile_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/strings.dart';
import 'package:wechat_clone/widgets/custom_back_button.dart';
import 'package:wechat_clone/widgets/custom_text_field_widget.dart';
import 'package:wechat_clone/widgets/loading_view.dart';

class SignUpPageTwo extends StatelessWidget {
  const SignUpPageTwo({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBlocTwo(phoneNumber),
      child: Builder(builder: (context) {
        final bloc = context.read<RegisterBlocTwo>();
        return Selector<RegisterBlocTwo, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: const CustomBackButton(),
                  ),
                  body: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMarginXLarge2),
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

                          CustomTextFieldWidget(
                              labelText: "Name",
                              onChanged: (text) {
                                bloc.onChangeName(text);
                              }),

                          const SizedBox(
                            height: kMarginLarge,
                          ),
                          const Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontSize: kTextSmall, color: kGreyTextColor),
                          ),

                          const SizedBox(
                            height: kMarginMedium,
                          ),

                          DOBView(
                            onChangeDay: (text) {
                              bloc.onChangeDay(text ?? "");
                            },
                            onChangeMonth: (text) {
                              bloc.onChangeMonth(text ?? "");
                            },
                            onChangeYear: (text) {
                              bloc.onChangeYear(text ?? "");
                            },
                          ),

                          const SizedBox(
                            height: kMarginLarge,
                          ),
                          const Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: kTextSmall, color: kGreyTextColor),
                          ),

                          const SizedBox(
                            height: kMarginMedium,
                          ),

                          /// SELECT GENDER VIEW
                          Selector<RegisterBlocTwo, String?>(
                            selector: (context, bloc) => bloc.gender,
                            builder: (context, gender, child) {
                              return GenderSelectView(
                                gender: gender ?? "",
                                onChangeGender: (value) {
                                  bloc.onChangeGender(value);
                                },
                              );
                            },
                          ),

                          const SizedBox(
                            height: kMarginLarge,
                          ),
                          CustomTextFieldWidget(
                              labelText: "Email",
                              onChanged: (text) {
                                bloc.onChangeEmail(text);
                              }),

                          const SizedBox(
                            height: kMarginLarge,
                          ),
                          CustomTextFieldWidget(
                              labelText: "Password",
                              onChanged: (text) {
                                bloc.onChangePassword(text);
                              }),

                          const SizedBox(
                            height: kMargin50,
                          ),

                          const _TermsAndConditionView(),

                          const SizedBox(
                            height: 70,
                          ),

                          Center(
                              child: PrimaryButtonWidget(
                                  onTap: () {
                                    bloc
                                        .onTapSignUp()
                                        .then((value) =>
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UploadProfilePage(),
                                                ),
                                                (route) => false))
                                        .catchError((error, _) =>
                                            showErrorSnackBarWithMessage(
                                                context, error.toString()));
                                  },
                                  label: "Sign Up"))
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

class DOBView extends StatelessWidget {
  const DOBView({
    super.key,
    required this.onChangeDay,
    required this.onChangeMonth,
    required this.onChangeYear,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
  });

  final void Function(String?) onChangeDay;
  final void Function(String?) onChangeMonth;
  final void Function(String?) onChangeYear;
  final String? selectedDay;
  final String? selectedMonth;
  final String? selectedYear;
  @override
  Widget build(BuildContext context) {
    return DropdownDatePicker(
      hintDay: selectedDay ?? "Day",
      hintMonth: selectedMonth ?? "Month",
      hintYear: selectedYear ?? "Year",
      icon: const Icon(
        Icons.arrow_drop_down,
        color: kDefaultTextColor,
      ),
      isExpanded: true,
      dateformatorder: OrderFormat.DMY, // default is myd
      inputDecoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
      ),
      isDropdownHideUnderline: true, // optional
      isFormValidator: true, // optional
      startYear: 1900, // optional
      endYear: 2020, // optional
      width: 10,
      dayFlex: 3, // optional
      monthFlex: 5,
      yearFlex: 4,
      onChangedDay: (value) => onChangeDay(value),
      onChangedMonth: (value) => onChangeMonth(value),
      onChangedYear: (value) => onChangeYear(value),

      boxDecoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDBDBDB),
            blurRadius: 4,
            offset: Offset(0, 5),
            spreadRadius: 0,
          )
        ],
      ),
      hintTextStyle: const TextStyle(
          color: kDefaultTextColor,
          fontFamily: kYorkieDemo,
          // decorationColor: kDefaultTextColor,
          fontWeight: FontWeight.normal), // optional
    );
  }
}

class GenderSelectView extends StatelessWidget {
  const GenderSelectView({
    super.key,
    required this.onChangeGender,
    required this.gender,
  });

  final void Function(String) onChangeGender;
  final String gender;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: kPrimaryColor,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: kGenderMale,
          groupValue: gender,
          onChanged: (value) {
            if (value != null) {
              onChangeGender(value);
            }
          },
        ),
        const SizedBox(
          width: kMarginMedium,
        ),
        const Text(
          kGenderMale,
          style:
              TextStyle(fontFamily: kYorkieDemo, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: kMarginMedium4,
        ),
        Radio(
          activeColor: kPrimaryColor,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: kGenderFemale,
          groupValue: gender,
          onChanged: (value) {
            if (value != null) {
              onChangeGender(value);
            }
          },
        ),
        const SizedBox(
          width: kMarginMedium,
        ),
        const Text(
          kGenderFemale,
          style:
              TextStyle(fontFamily: kYorkieDemo, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _TermsAndConditionView extends StatefulWidget {
  const _TermsAndConditionView();

  @override
  State<_TermsAndConditionView> createState() => _TermsAndConditionViewState();
}

class _TermsAndConditionViewState extends State<_TermsAndConditionView> {
  @override
  Widget build(BuildContext context) {
    return Selector<RegisterBlocTwo, bool>(
      selector: (context, bloc) => bloc.isTnCChecked,
      builder: (context, isChecked, child) {
        return Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(),
              child: Checkbox(
                visualDensity: VisualDensity.compact,
                value: isChecked,
                overlayColor: MaterialStateProperty.resolveWith(
                    (states) => kPrimaryColor),
                fillColor: MaterialStateProperty.resolveWith(
                    (states) => isChecked ? kPrimaryColor : Colors.white),
                onChanged: (value) {
                  final bloc = context.read<RegisterBlocTwo>();
                  bloc.onClickTnC(value ?? false);
                },
              ),
            ),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: "Agree To",
                  style: TextStyle(
                    color: kDefaultTextColor.withOpacity(0.5),
                    fontFamily: kNotoSans,
                    fontSize: kTextSmall,
                  )),
              const TextSpan(
                  text: " Terms And Services",
                  style: TextStyle(
                    color: kDefaultTextColor,
                    fontFamily: kNotoSans,
                    fontSize: kTextSmall,
                  )),
            ]))
          ],
        );
      },
    );
  }
}
