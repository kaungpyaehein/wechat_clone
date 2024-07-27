import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/upload_profile_bloc.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

import '../../widgets/loading_view.dart';

class UploadProfilePage extends StatelessWidget {
  const UploadProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UploadProfileBloc(),
      child: Selector<UploadProfileBloc, bool>(
        selector: (context, bloc) => bloc.isLoading,
        builder: (context, isLoading, child) {
          return Stack(
            children: [
              Selector<UploadProfileBloc, File?>(
                selector: (context, bloc) => bloc.image,
                builder: (context, image, child) {
                  final bloc = context.read<UploadProfileBloc>();
                  return Scaffold(
                    appBar: buildAppBar(context),
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            GestureDetector(
                              onTap: () {
                                bloc.onChooseImage();
                              },
                              child: image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(300),
                                      child: Image.file(
                                        image,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          color: kGreyTextColor,
                                          shape: BoxShape.circle),
                                      child: const Center(
                                          child: Text(
                                        "Pick Image",
                                        style: TextStyle(
                                            color: kDefaultTextColor,
                                            fontSize: kTextRegular3X,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PrimaryButtonWidget(
                                  size: const Size(150, 50),
                                  label: 'Choose',
                                  backgroundColor: Colors.white,
                                  labelColor: kPrimaryColor,
                                  onTap: () {
                                    bloc.onChooseImage();
                                  },
                                ),
                                PrimaryButtonWidget(
                                  size: const Size(150, 50),
                                  label: 'Upload',
                                  onTap: () {
                                    bloc.uploadProfileImage().then((_) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                          (route) => false);
                                    }).catchError((error) {
                                      showErrorSnackBarWithMessage(
                                          context, error.toString());
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text("Upload Profile",
          style: TextStyle(
              color: kPrimaryColor,
              fontSize: kTextHeading1X,
              fontWeight: FontWeight.w600,
              fontFamily: kYorkieDemo)),
      actions: [
        PrimaryButtonWidget(
            padding: const EdgeInsets.all(kMarginMedium),
            size: const Size(kMarginXXLarge3, kMarginXLarge2),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
            label: "Skip"),
        const SizedBox(
          width: kMarginMedium3,
        ),
      ],
    );
  }
}
