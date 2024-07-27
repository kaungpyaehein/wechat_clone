import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.labelText,
    this.isPasswordField,
    required this.onChanged,
    this.inputType,
    this.isAutoFocus,
    this.maxLength,
    this.initialValue,
  });

  final String labelText;
  final bool? isPasswordField;
  final void Function(String) onChanged;
  final TextInputType? inputType;
  final bool? isAutoFocus;
  final int? maxLength;
  final String? initialValue;

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late String currentText;

  @override
  void initState() {
    super.initState();
    currentText = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {
          currentText = text;
        });
        widget.onChanged(text);
      },
      keyboardType: widget.inputType,
      obscureText: widget.isPasswordField ?? false,
      autofocus: widget.isAutoFocus ?? false,
      style: const TextStyle(
          color: kDefaultTextColor,
          fontSize: kTextRegular2X,
          fontFamily: kYorkieDemo),
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kDefaultTextColor, width: 1),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kDefaultTextColor, width: 1),
          ),
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle:
          const TextStyle(fontSize: kTextSmall, color: kGreyTextColor),
          floatingLabelStyle:
          const TextStyle(fontSize: kTextSmall, color: kGreyTextColor)),
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: currentText,
          selection: TextSelection.collapsed(offset: currentText.length),
        ),
      ),
    );
  }
}
