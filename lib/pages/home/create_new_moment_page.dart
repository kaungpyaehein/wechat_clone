import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/create_moment_bloc.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/widgets/svg_widget.dart';

class CreateNewMomentPage extends StatelessWidget {
  const CreateNewMomentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateMomentBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: SingleChildScrollView(
              child: Consumer<CreateMomentBloc>(
                builder: (context, bloc, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: kMarginMedium4,
                      ),

                      /// Profile
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(kMarginXLarge2),
                            child: Image.network(
                              bloc.userVO?.profileImage ?? "",
                              height: kMargin50,
                              width: kMargin50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: kGreyTextColor,
                                height: kMarginXLarge2,
                                width: kMarginXLarge2,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: kMarginMedium2,
                          ),
                          Text(
                            bloc.userVO?.name ?? "",
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: kText18),
                          ),
                        ],
                      ),

                      /// TextField
                      TextField(
                        onChanged: (text) => bloc.onChangText(text),
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: kTextRegular2X),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "What’s on your mind",
                          hintStyle: TextStyle(
                              color: kGreyTextColor,
                              fontSize: kText18,
                              fontWeight: FontWeight.normal),
                        ),
                        maxLines: 15,
                      ),
                      const SizedBox(
                        height: kMarginMedium2,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CreateMomentImageView(
                            imageWidth: 108,
                            imageHeight: 108,
                            borderRadius: kMarginMedium4,
                            imageFile:
                                bloc.images.isNotEmpty ? bloc.images[0] : null,
                          ),
                          const SizedBox(
                            width: kMarginMedium,
                          ),
                          CreateMomentImageView(
                            imageWidth: 108,
                            imageHeight: 108,
                            borderRadius: kMarginMedium4,
                            imageFile:
                                bloc.images.length > 1 ? bloc.images[1] : null,
                          ),
                          const SizedBox(
                            width: kMarginMedium,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(kMarginMedium4),
                            onTap: () {
                              bloc.onChooseImages();
                            },
                            child: Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kMarginMedium4),
                                border:
                                    Border.all(color: kPrimaryColor, width: 2),
                              ),
                              child: const Center(
                                child: SvgImageWidget(
                                  imagePath: kAddIconBig,
                                  height: kMarginXLarge2,
                                  width: kMarginXLarge2,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.clear),
        color: kPrimaryColor,
        iconSize: kMarginXLarge,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 2,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(
        "New Moment",
        style: TextStyle(
            color: kPrimaryColor,
            fontSize: kTextHeading1X,
            fontWeight: FontWeight.w600,
            fontFamily: kYorkieDemo),
      ),
      actions: [
        PrimaryButtonWidget(
            padding: const EdgeInsets.all(kMarginMedium),
            size: const Size(kMarginXXLarge3, kMarginXLarge2),
            onTap: () {
              final bloc = context.read<CreateMomentBloc>();
              bloc.onTapCreateMoment().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),),
                        (route) => false);
              }).catchError((error) {
                showErrorSnackBarWithMessage(context, error);
              });
            },
            label: "Create"),
        const SizedBox(
          width: kMarginMedium3,
        ),
      ],
    );
  }
}

class MomentImageView extends StatelessWidget {
  const MomentImageView({
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.boxFit,
    required this.imageUrl,
    this.borderRadius,
  });

  final double? imageHeight;
  final double? imageWidth;
  final BoxFit? boxFit;
  final double? borderRadius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if ((imageUrl?.isEmpty ?? false || imageUrl == null)) {
      return const SizedBox.shrink();
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? kMargin5),
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: boxFit ?? BoxFit.cover,
            height: imageHeight ?? 200,
            width: imageWidth ?? double.infinity,
            errorWidget: (context, error, stackTrace) => Container(
              color: kGreyTextColor,
              height: 200,
              width: double.infinity,
            ),
          ));
    }
  }
}

class CreateMomentImageView extends StatelessWidget {
  const CreateMomentImageView({
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.boxFit,
    this.imageFile,
    this.borderRadius,
  });

  final double? imageHeight;
  final double? imageWidth;
  final BoxFit? boxFit;
  final double? borderRadius;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return imageFile == null
        ? const SizedBox.shrink()
        : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? kMargin5),
            child: Image.file(
              imageFile!,
              fit: boxFit ?? BoxFit.cover,
              height: imageHeight ?? 200,
              width: imageWidth ?? double.infinity,
            ));
  }
}
