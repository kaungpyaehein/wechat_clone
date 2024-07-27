import 'package:flutter/material.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';

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