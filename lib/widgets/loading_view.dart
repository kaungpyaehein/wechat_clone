import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: kMarginXXLarge,
          height: kMarginXXLarge,
          child: LoadingIndicator(
            indicatorType: Indicator.orbit,
            colors: [kPrimaryColor],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
