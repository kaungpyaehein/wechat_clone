import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/moment_feeds_bloc.dart';
import 'package:wechat_clone/data/vos/comment_vo.dart';
import 'package:wechat_clone/data/vos/moment_vo.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/home/chat_details_page.dart';
import 'package:wechat_clone/pages/home/create_new_moment_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/utils/route_extensions.dart';
import 'package:wechat_clone/widgets/custom_text_field_widget.dart';
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
        body: const MomentListView(),
      ),
    );
  }
}

class MomentListView extends StatelessWidget {
  const MomentListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kMarginMedium3, vertical: kMarginMedium3),
      child: Consumer<MomentFeedsBloc>(
        builder: (context, bloc, child) {
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: kMarginXXLarge,
            ),
            itemCount: bloc.moments.length,
            itemBuilder: (context, index) {
              return MomentItemView(
                momentVO: bloc.moments[index],
              );
            },
          );
        },
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
  const MomentItemView({super.key, required this.momentVO});

  final MomentVO momentVO;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile View
        ProfileView(
          momentVO: momentVO,
        ),

        /// Text and Images View

        const SizedBox(
          height: kMargin12,
        ),
        Text(
          momentVO.text ?? "",
          style: const TextStyle(
              color: kPrimaryColor,
              fontSize: kTextRegular2X,
              fontWeight: FontWeight.w500),
        ),

        const SizedBox(
          height: kMargin12,
        ),
        ImageView(momentV0: momentVO),

        /// Like and Comment View
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<MomentFeedsBloc>(
              builder: (context, bloc, child) {
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        final bloc = context.read<MomentFeedsBloc>();
                        bloc.onTapLike(momentVO.momentId ?? "");
                      },
                      child: SvgImageWidget(
                          height: kDefaultIconSize,
                          width: kDefaultIconSize,
                          imagePath: bloc.isLiked(momentVO.likes ?? [])
                              ? kLikeIconFilled
                              : kLikeIcon),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      momentVO.likes?.length.toString() ?? "0",
                      style: TextStyle(
                        color: bloc.isLiked(momentVO.likes ?? [])
                            ? kRedSelectedColor
                            : kDefaultTextColor,
                        fontSize: kText15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                final bloc = context.read<MomentFeedsBloc>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (context) => ListenableProvider.value(
                    value: bloc,
                    child: FractionallySizedBox(
                        heightFactor: 0.5,
                        child: CommentBottomSheetView(momentVO: momentVO)),
                  ),
                );
              },
              child: const SvgImageWidget(
                  height: kDefaultIconSize,
                  width: kDefaultIconSize,
                  imagePath: kCommentIcon),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              momentVO.comments?.length.toString() ?? "0",
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

class CommentBottomSheetView extends StatelessWidget {
  const CommentBottomSheetView({
    super.key,
    required this.momentVO,
  });

  final MomentVO momentVO;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium3),
      child: Column(
        children: [
          const DraggerView(),

          /// TITLE
          CommentsSheetTitleView(
            onAddButtonPressed: () {
              final bloc = context.read<MomentFeedsBloc>();
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) => ListenableProvider.value(
                  value: bloc,
                  child: FractionallySizedBox(
                      heightFactor: 0.5,
                      child: AddCommentBottomSheetView(momentVO: momentVO)),
                ),
              );
            },
          ),

          /// COMMENTS
          Expanded(
            child: CommentListView(momentVO: momentVO),
          )
        ],
      ),
    );
  }
}

class AddCommentBottomSheetView extends StatelessWidget {
  const AddCommentBottomSheetView({
    super.key,
    required this.momentVO,
  });

  final MomentVO momentVO;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MomentFeedsBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium3),
      child: Column(
        children: [
          const DraggerView(),

          // Title
          const Text(
            "Add new comment",
            style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kYorkieDemo,
                fontWeight: FontWeight.bold,
                fontSize: kTextHeading1X),
          ),

          const SizedBox(
            height: kMarginSmall,
          ),

          CustomTextFieldWidget(
            isAutoFocus: true,
            labelText: "Comment as ${momentVO.userName}",
            onChanged: (text) {
              bloc.onChangeCommentText(text);
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryButtonWidget(
                  backgroundColor: Colors.white,
                  size: const Size(double.infinity, 50),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  labelColor: kDefaultTextColor,
                  label: "Cancel"),
              PrimaryButtonWidget(
                  size: const Size(double.infinity, 50),
                  backgroundColor: kPrimaryColor,
                  labelColor: Colors.white,
                  onTap: () {
                    bloc.onAddNewComment(momentVO.momentId ?? "").then((value) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      showErrorSnackBarWithMessage(context, error.toString());
                    });
                  },
                  label: "Comment")
            ],
          ),

          const SizedBox(
            height: kMarginMedium4,
          )
        ],
      ),
    );
  }
}

class CommentsSheetTitleView extends StatelessWidget {
  const CommentsSheetTitleView({
    super.key,
    required this.onAddButtonPressed,
  });
  final void Function()? onAddButtonPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: kMarginXLarge2,
        ),
        const Spacer(),
        const Text(
          "Comments",
          style: TextStyle(
              color: kPrimaryColor,
              fontFamily: kYorkieDemo,
              fontWeight: FontWeight.bold,
              fontSize: kTextHeading1X),
        ),
        const Spacer(),
        IconButton(
          onPressed: onAddButtonPressed,
          icon: const Icon(
            Icons.add_circle_outline,
            color: kPrimaryColor,
            size: kMarginXLarge,
          ),
        ),
      ],
    );
  }
}

class CommentListView extends StatelessWidget {
  const CommentListView({
    super.key,
    required this.momentVO,
  });

  final MomentVO momentVO;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CommentItemView(commentVO: momentVO.comments?[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: kMarginMedium,
            ),
        itemCount: momentVO.comments?.length ?? 0);
  }
}

class CommentItemView extends StatelessWidget {
  const CommentItemView({
    super.key,
    this.commentVO,
  });

  final CommentVO? commentVO;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile
        ClipRRect(
          borderRadius: BorderRadius.circular(kMarginXLarge2),
          child: Image.network(
            commentVO?.userProfile ?? '',
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
          width: kMarginMedium2,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: kChatContainerColor,
              borderRadius: BorderRadius.circular(kMarginMedium),
            ),
            padding: const EdgeInsets.all(kMarginMedium2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                Text(
                  commentVO?.userName ?? "",
                  style: const TextStyle(
                    color: kDefaultTextColor,
                    fontSize: kTextRegular,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: kMarginSmall),
                Text(
                  commentVO?.commentText ?? "",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kGreyTextColor,
                    fontSize: kTextRegular,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DraggerView extends StatelessWidget {
  const DraggerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kMarginMedium2,
        ),
        Container(
          width: 44,
          height: 4,
          decoration: ShapeDecoration(
            color: const Color(0xFFDEDEDE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(
          height: kMarginMedium2,
        ),
      ],
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({
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
