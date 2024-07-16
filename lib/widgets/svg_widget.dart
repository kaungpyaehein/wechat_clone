import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wechat_clone/utils/colors.dart';

class SvgImageWidget extends StatelessWidget {
  const SvgImageWidget(
      {super.key,
      required this.imagePath,
      this.height,
      this.width,
      this.color});
  final String imagePath;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.cover,
      color: color ?? kPrimaryColor,
    );
  }
}
