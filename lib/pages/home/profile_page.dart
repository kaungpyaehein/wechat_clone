import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/profile_bloc.dart';
import 'package:wechat_clone/pages/auth/login_page.dart';
import 'package:wechat_clone/pages/auth/sign_up_page_two.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/persistence/daos/user_dao.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/extensions.dart';
import 'package:wechat_clone/utils/fonts.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/utils/route_extensions.dart';
import 'package:wechat_clone/widgets/custom_text_field_widget.dart';
import 'package:wechat_clone/widgets/loading_view.dart';
import 'package:wechat_clone/widgets/svg_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileBloc(),
      child: Builder(builder: (context) {
        return Selector<ProfileBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) {
            return Stack(
              children: [
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: buildDefaultAppBar(
                    context: context,
                    title: "Me",
                    iconPath: kEditIcon,
                    onTap: () {
                      final bloc = context.read<ProfileBloc>();
                      showDialog(
                        context: context,
                        builder: (context) => ListenableProvider.value(
                          value: bloc,
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kMargin5)),
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: kMarginMedium4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(kMargin5)),
                              child: Consumer<ProfileBloc>(
                                  builder: (context, bloc, child) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextFieldWidget(
                                          initialValue: bloc.name,
                                          labelText: "Name",
                                          onChanged: (text) {
                                            bloc.onChangeName(text);
                                          }),

                                      const SizedBox(
                                        height: kMarginMedium4,
                                      ),
                                      CustomTextFieldWidget(
                                          initialValue: bloc.phone,
                                          inputType: TextInputType.phone,
                                          labelText: "Phone Number",
                                          onChanged: (text) {
                                            bloc.onChangePhone(text);
                                          }),

                                      const SizedBox(
                                        height: kMarginMedium4,
                                      ),
                                      const Text(
                                        "Date of Birth",
                                        style: TextStyle(
                                            fontSize: kTextSmall,
                                            color: kGreyTextColor),
                                      ),

                                      const SizedBox(
                                        height: kMarginMedium,
                                      ),

                                      DOBView(
                                          selectedDay: bloc.day,
                                          selectedMonth: bloc.monthHintText,
                                          selectedYear: bloc.year,
                                          onChangeDay: (value) =>
                                              bloc.onChangeDay(value ?? ""),
                                          onChangeMonth: (value) =>
                                              bloc.onChangeMonth(value ?? ""),
                                          onChangeYear: (value) =>
                                              bloc.onChangeYear(value ?? "")),

                                      const SizedBox(
                                        height: kMarginLarge,
                                      ),
                                      const Text(
                                        "Gender",
                                        style: TextStyle(
                                            fontSize: kTextSmall,
                                            color: kGreyTextColor),
                                      ),

                                      const SizedBox(
                                        height: kMarginMedium,
                                      ),

                                      /// SELECT GENDER VIEW
                                      GenderSelectView(
                                        gender: bloc.gender,
                                        onChangeGender: (value) {
                                          bloc.onChangeGender(value);
                                        },
                                      ),

                                      const SizedBox(
                                        height: kMarginLarge,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          PrimaryButtonWidget(
                                              size: const Size(100, 50),
                                              padding: EdgeInsets.zero,
                                              backgroundColor: Colors.white,
                                              labelColor: kPrimaryColor,
                                              onTap: () {
                                                // bloc.loadInitialData();
                                                context.pop();
                                              },
                                              label: "Cancel"),
                                          PrimaryButtonWidget(
                                              size: const Size(100, 50),
                                              padding: EdgeInsets.zero,
                                              onTap: () {
                                                bloc
                                                    .onTapConfirm()
                                                    .whenComplete(() => Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomePage(
                                                                          selectedIndex:
                                                                              3,
                                                                        )),
                                                            (route) => false))
                                                    .catchError((error, _) =>
                                                        showErrorSnackBarWithMessage(
                                                            context,
                                                            error.toString()));
                                              },
                                              label: "Confirm"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: kMarginLarge,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  body: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: kMarginMedium2,
                        ),

                        /// PROFILE CARD
                        ProfileCardView()
                      ],
                    ),
                  ),
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
        );
      }),
    );
  }
}

class ProfileCardView extends StatelessWidget {
  const ProfileCardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileBloc>(builder: (context, bloc, child) {
      return Container(
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
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  width: 120,
                  color: kGreyTextColor,
                ),
                imageUrl: bloc.currentUser?.profileImage ?? "",
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
                    bloc.currentUser?.name ?? "",
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
                    label: bloc.currentUser?.phone ?? "",
                  ),
                  const SizedBox(
                    height: kMarginMedium,
                  ),
                  _LabelAndIconView(
                    iconPath: kEmailIcon,
                    label: bloc.currentUser?.email ?? "",
                  ),
                  const SizedBox(
                    height: kMarginMedium,
                  ),
                  _LabelAndIconView(
                    iconPath: kDateIcon,
                    label: bloc.currentUser?.dob ?? "",
                  ),
                  const SizedBox(
                    height: kMarginMedium,
                  ),
                  _LabelAndIconView(
                    iconPath: kGenderIcon,
                    label: bloc.currentUser?.gender ?? "",
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
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
