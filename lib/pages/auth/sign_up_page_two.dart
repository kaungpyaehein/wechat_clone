import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

class SignUpPageTwo extends StatelessWidget {
  const SignUpPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

              CustomTextFieldWidget(
                  labelText: "Enter Your Phone Number", onChanged: (text) {}),

              const SizedBox(
                height: kMarginLarge,
              ),
              const Text(
                "Date of Birth",
                style: TextStyle(fontSize: kTextSmall, color: kGreyTextColor),
              ),

              const SizedBox(
                height: kMarginMedium,
              ),

              DropdownDatePicker(
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
                // optional
                isDropdownHideUnderline: true, // optional
                isFormValidator: true, // optional
                startYear: 1900, // optional
                endYear: 2020, // optional
                width: 10,
                dayFlex: 2, // optional
                monthFlex: 3,
                yearFlex: 2,
                // // selectedDay: 14, // optional
                // selectedMonth: null, // optional
                // selectedYear: 1993, // optional
                onChangedDay: (value) => print('onChangedDay: $value'),
                onChangedMonth: (value) => print('onChangedMonth: $value'),
                onChangedYear: (value) => print('onChangedYear: $value'),
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
                // optional
                // showDay: false,// optional
                // dayFlex: 2,// optional
                // locale: "zh_CN",// optional
                // hintDay: 'Day', // optional
                // hintMonth: 'Month', // optional
                // hintYear: 'Year', // optional
                hintTextStyle: const TextStyle(
                    color: kDefaultTextColor,
                    fontFamily: kYorkieDemo,
                    // decorationColor: kDefaultTextColor,
                    fontWeight: FontWeight.normal), // optional
              ),

              const SizedBox(
                height: kMarginLarge,
              ),
              CustomTextFieldWidget(
                  labelText: "Enter Your Email", onChanged: (text) {}),

              const SizedBox(
                height: kMarginLarge,
              ),
              CustomTextFieldWidget(
                  labelText: "Enter Your Password", onChanged: (text) {}),

              const SizedBox(
                height: kMargin50,
              ),

              const _TermsAndConditionView(),

              const SizedBox(
                height: 70,
              ),

              Center(child: PrimaryButtonWidget(onTap: () {}, label: "Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditionView extends StatefulWidget {
  const _TermsAndConditionView();

  @override
  State<_TermsAndConditionView> createState() => _TermsAndConditionViewState();
}

class _TermsAndConditionViewState extends State<_TermsAndConditionView> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(),
          child: Checkbox(
            visualDensity: VisualDensity.compact,
            value: isChecked,
            overlayColor:
                MaterialStateProperty.resolveWith((states) => kPrimaryColor),
            fillColor: MaterialStateProperty.resolveWith(
                (states) => isChecked ? kPrimaryColor : Colors.white),
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
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
  }
}
