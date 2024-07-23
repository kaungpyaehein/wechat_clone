import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/persistence/daos/user_dao.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/widgets/svg_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userVO = UserDao().getUserData();
    return Scaffold(
      appBar: buildDefaultAppBar(
        context: context,
        title: "Me",
        iconPath: kEditIcon,
        onTap: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        child: Column(
          children: [
            const SizedBox(
              height: kMarginMedium2,
            ),

            /// PROFILE CARD
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(kMarginMedium),
              ),
              padding: const EdgeInsets.all(kMargin12),
              child: Row(
                children: [
                  /// Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: CachedNetworkImage(
                      imageUrl: userVO?.profileImage ?? "",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(
                    width: kMarginLarge,
                  ),

                  /// Infos
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userVO?.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: kTextRegular3X,
                              fontWeight: FontWeight.w400,
                              fontFamily: kYorkieDemo),
                        ),
                        const SizedBox(
                          height: kMarginMedium,
                        ),
                        _LabelAndIconView(
                          iconPath: kPhoneIcon,
                          label: userVO?.phone ?? "",
                        ),
                        const SizedBox(
                          height: kMarginMedium,
                        ),
                        _LabelAndIconView(
                          iconPath: kEmailIcon,
                          label: userVO?.email ?? "",
                        ),
                        const SizedBox(
                          height: kMarginMedium,
                        ),
                        _LabelAndIconView(
                          iconPath: kDateIcon,
                          label: userVO?.dob ?? "",
                        ),
                        const SizedBox(
                          height: kMarginMedium,
                        ),
                        _LabelAndIconView(
                          iconPath: kGenderIcon,
                          label: userVO?.gender ?? "",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LabelAndIconView extends StatelessWidget {
  const _LabelAndIconView({
    required this.label,
    required this.iconPath,
  });
  final String label;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgImageWidget(
          imagePath: iconPath,
          height: kDefaultIconSize,
          width: kDefaultIconSize,
        ),
        const SizedBox(
          width: kMarginMedium,
        ),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontSize: kTextRegular,
            ),
          ),
        )
      ],
    );
  }
}
