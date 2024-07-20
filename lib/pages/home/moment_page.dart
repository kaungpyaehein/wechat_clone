import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/create_new_moment_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/widgets/svg_widget.dart';

class MomentPage extends StatelessWidget {
  const MomentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: buildDefaultAppBar(
        context: context,
        title: "Moments",
        iconPath: kAddIconAppBar,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateNewMomentPage(),
              ));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kMarginMedium3, vertical: kMarginMedium3),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return const MomentItemView();
          },
        ),
      ),
    );
  }


}
AppBar buildDefaultAppBar(
    {required BuildContext context,
      required String title,
      required String iconPath,
      required void Function() onTap}) {
  return AppBar(
    elevation: 2,
    centerTitle: false,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: const TextStyle(
          color: kPrimaryColor,
          fontSize: 34,
          fontWeight: FontWeight.w600,
          fontFamily: kYorkieDemo),
    ),
    actions: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kMarginMedium2),
        child: SvgImageWidget(
          imagePath: iconPath,
          height: 35,
          width: 35,
        ),
      ),
      const SizedBox(
        width: kMarginMedium3,
      ),
    ],
  );
}
class MomentItemView extends StatelessWidget {
  const MomentItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile View
          const ProfileView(),

          /// Text and Images View
          ///
          const SizedBox(
            height: kMargin12,
          ),
          const Text(
            "A machine resembling a human being and able to replicate certain human movements and functions automatically.",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: kTextRegular2X,
                fontWeight: FontWeight.w500),
          ),

          const SizedBox(
            height: kMargin12,
          ),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MomentImageView(
                  imageWidth:
                      (MediaQuery.of(context).size.width - kMarginXLarge2) / 2,
                  imageUrl:
                      "https://images.unsplash.com/photo-1721146378270-1b93839f7ae7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
                const SizedBox(
                  width: kMarginMedium,
                ),
                MomentImageView(
                  imageWidth:
                      (MediaQuery.of(context).size.width - kMarginXLarge2) / 2,
                  imageUrl:
                      "https://images.unsplash.com/photo-1721146378270-1b93839f7ae7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ],
            ),
          ),

          const SizedBox(
            height: kMargin15,
          ),

          /// Like and Comment View
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgImageWidget(
                  height: kDefaultIconSize,
                  width: kDefaultIconSize,
                  imagePath: kLikeIconFilled),
              SizedBox(
                width: 2,
              ),
              Text(
                '10',
                style: TextStyle(
                  color: kRedSelectedColor,
                  fontSize: kText15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              SvgImageWidget(
                  height: kDefaultIconSize,
                  width: kDefaultIconSize,
                  imagePath: kCommentIcon),
              SizedBox(
                width: 2,
              ),
              Text(
                '10',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: kText15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: kMarginMedium,
              ),
              SvgImageWidget(
                  height: kDefaultIconSize,
                  width: kDefaultIconSize,
                  imagePath: kBookMarkIcon),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kMarginXLarge2),
          child: Image.network(
            "https://is1-ssl.mzstatic.com/image/thumb/DoYfxrZ6E9WrFy8TLhOmsQ/1200x675mf.jpg",
            height: kMarginXLarge2,
            width: kMarginXLarge2,
            fit: BoxFit.cover,
            // loadingBuilder: (context, error, stackTrace) => Container(
            //   color: kGreyTextColor,
            //   height: kMarginXLarge2,
            //   width: kMarginXLarge2,
            // ),
            errorBuilder: (context, error, stackTrace) => Container(
              color: kGreyTextColor,
              height: kMarginXLarge2,
              width: kMarginXLarge2,
            ),
          ),
        ),
        const SizedBox(
          width: kMarginSmall,
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Michael",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: kTextRegular2X),
            ),
            Text(
              "15 min ago",
              style: TextStyle(color: kGreyTextColor, fontSize: kTextSmall),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.more_horiz,
          color: kPrimaryColor,
          size: kMarginLarge + 1,
        )
      ],
    );
  }
}
