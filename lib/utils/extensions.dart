import 'package:flutter/material.dart';
import 'package:wechat_clone/utils/colors.dart';

extension NavigationUtility on Widget {
  void navigateToScreen(BuildContext context, Widget nextScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  void showSnackBarWithMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void showErrorSnackBarWithMessage(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: kRedSelectedColor,
      ),
    );
  }
}