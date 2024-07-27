import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.labelText,
    this.isPasswordField,
    required this.onChanged,
    this.inputType,
    this.isAutoFocus,
    this.maxLength,
  });

  final String labelText;
  final bool? isPasswordField;
  final void Function(String) onChanged;
  final TextInputType? inputType;
  final bool? isAutoFocus;
  final int? maxLength;

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
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
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
