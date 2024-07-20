import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/widgets/svg_widget.dart';

class CreateNewMomentPage extends StatelessWidget {
  const CreateNewMomentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        child: SingleChildScrollView(
          child: Column(
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
                      "https://is1-ssl.mzstatic.com/image/thumb/DoYfxrZ6E9WrFy8TLhOmsQ/1200x675mf.jpg",
                      height: kMargin50,
                      width: kMargin50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: kGreyTextColor,
                        height: kMarginXLarge2,
                        width: kMarginXLarge2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kMarginMedium2,
                  ),
                  const Text(
                    "Michael",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: kText18),
                  ),
                ],
              ),

              /// TextField
              const TextField(
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: kTextRegular2X),
                decoration: InputDecoration(
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
                  const MomentImageView(
                    imageWidth: 108,
                    imageHeight: 108,
                    borderRadius: kMarginMedium4,
                    imageUrl:
                        "https://images.unsplash.com/photo-1721146378270-1b93839f7ae7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ),
                  const SizedBox(
                    width: kMarginMedium,
                  ),
                  const MomentImageView(
                    imageWidth: 108,
                    imageHeight: 108,
                    borderRadius: kMarginMedium4,
                    imageUrl:
                        "https://images.unsplash.com/photo-1721146378270-1b93839f7ae7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  ),
                  const SizedBox(
                    width: kMarginMedium,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(kMarginMedium4),
                    onTap: () {},
                    child: Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kMarginMedium4),
                        border: Border.all(color: kPrimaryColor, width: 2),
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
          ),
        ),
      ),
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
            onTap: () {},
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
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? kMargin5),
        child: CachedNetworkImage(
          imageUrl:
              "https://images.unsplash.com/photo-1721146378270-1b93839f7ae7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
