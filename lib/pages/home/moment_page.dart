import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/moment_feeds_bloc.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
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
    return ChangeNotifierProvider(
      create: (context) => MomentFeedsBloc(),
      child: Scaffold(
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
          child: Selector<MomentFeedsBloc, List<MomentVO>>(
            selector: (context, bloc) => bloc.moments,
            builder: (context, moments, child) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: kMarginLarge,
                ),
                itemCount: moments.length,
                itemBuilder: (context, index) {
                  return MomentItemView(
                    momentV0: moments[index],
                  );
                },
              );
            },
          ),
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
  const MomentItemView({super.key, required this.momentV0});

  final MomentVO momentV0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile View
        ProfileView(
          momentVO: momentV0,
        ),

        /// Text and Images View

        const SizedBox(
          height: kMargin12,
        ),
        Text(
          momentV0.text ?? "",
          style: const TextStyle(
              color: kPrimaryColor,
              fontSize: kTextRegular2X,
              fontWeight: FontWeight.w500),
        ),

        const SizedBox(
          height: kMargin12,
        ),
        PhotoView(momentV0: momentV0),

        /// Like and Comment View
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SvgImageWidget(
                height: kDefaultIconSize,
                width: kDefaultIconSize,
                imagePath: kLikeIconFilled),
            const SizedBox(
              width: 2,
            ),
            Text(
              momentV0.likes?.length.toString() ?? "0",
              style: const TextStyle(
                color: kRedSelectedColor,
                fontSize: kText15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const SvgImageWidget(
                height: kDefaultIconSize,
                width: kDefaultIconSize,
                imagePath: kCommentIcon),
            const SizedBox(
              width: 2,
            ),
            Text(
              momentV0.comments?.length.toString() ?? "0",
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: kText15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: kMarginMedium,
            ),
            const SvgImageWidget(
                height: kDefaultIconSize,
                width: kDefaultIconSize,
                imagePath: kBookMarkIcon),
          ],
        )
      ],
    );
  }
}

class PhotoView extends StatelessWidget {
  const PhotoView({
    super.key,
    required this.momentV0,
  });

  final MomentVO momentV0;

  bool _hasPhoto(String? url) {
    return url != null && url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final hasPhotoOne = _hasPhoto(momentV0.photoOneUrl);
    final hasPhotoTwo = _hasPhoto(momentV0.photoTwoUrl);

    if (!hasPhotoOne && !hasPhotoTwo) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kMargin15),
      child: SizedBox(
        height: 200,
        child: hasPhotoOne && hasPhotoTwo
            ? Row(
                children: [
                  MomentImageView(
                    imageWidth:
                        (MediaQuery.of(context).size.width - kMarginXLarge2) /
                            2,
                    imageUrl: momentV0.photoOneUrl!,
                  ),
                  const SizedBox(
                    width: kMarginMedium,
                  ),
                  MomentImageView(
                    imageWidth:
                        (MediaQuery.of(context).size.width - kMarginXLarge2) /
                            2,
                    imageUrl: momentV0.photoTwoUrl!,
                  ),
                ],
              )
            : Center(
                child: MomentImageView(
                  imageWidth:
                      MediaQuery.of(context).size.width - kMarginXLarge2,
                  imageUrl: hasPhotoOne
                      ? momentV0.photoOneUrl!
                      : momentV0.photoTwoUrl!,
                ),
              ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.momentVO,
  });
  final MomentVO momentVO;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kMarginXLarge2),
          child: Image.network(
            momentVO.userProfile ?? '',
            height: kMarginXLarge2,
            width: kMarginXLarge2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: kGreyTextColor,
              height: kMarginXLarge2,
              width: kMarginXLarge2,
            ),
          ),
        ),
        const SizedBox(
          width: kMarginMedium,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              momentVO.userName ?? "",
              style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: kTextRegular2X),
            ),
            const Text(
              "15 min ago",
              style: TextStyle(color: kGreyTextColor, fontSize: kTextXSmall),
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
