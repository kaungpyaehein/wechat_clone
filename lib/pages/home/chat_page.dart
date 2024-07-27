import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/chat_list_bloc.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/pages/home/chat_details_page.dart';
import 'package:wechat_clone/pages/home/moment_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/images.dart';
import 'package:wechat_clone/utils/route_extensions.dart';
import 'package:wechat_clone/widgets/loading_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatListBloc(),
      child: Builder(builder: (context) {
        return Selector<ChatListBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, _) {
            return Stack(
              children: [
                Scaffold(
                  appBar: buildDefaultAppBar(
                      context: context,
                      title: "Chats",
                      iconPath: kSearchIcon,
                      onTap: () {}),
                  body: Selector<ChatListBloc, List<UserVO>>(
                    selector: (context, bloc) => bloc.activeChatList,
                    builder: (context, activeChatList, child) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: kMarginMedium2,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium3,
                            vertical: kMarginMedium3),
                        itemCount: activeChatList.length,
                        itemBuilder: (context, index) {
                          return ChatListItemView(
                            userVO: activeChatList[index],
                          );
                        },
                      );
                    },
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

class ChatListItemView extends StatelessWidget {
  const ChatListItemView({
    super.key,
    required this.userVO,
  });
  final UserVO userVO;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatListBloc>();

    return StreamBuilder(
        stream: bloc.getLatestMessageStreamByChatId(userVO.id ?? ""),
        builder: (context, snapshot) {
          final UserVO? currentUser = context.read<ChatListBloc>().userVo;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kMarginMedium),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F9C9C9C),
                    blurRadius: 4,
                    offset: Offset(1, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData &&
              snapshot.connectionState != ConnectionState.waiting) {
            final MessageVO messageVO = snapshot.data;
            return GestureDetector(
              onTap: () {
                context.push(ChatDetailsPage(userToChat: userVO));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kMarginMedium),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F9C9C9C),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(kMarginMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kMarginXLarge2),
                      child: Image.network(
                        userVO.profileImage ?? "",
                        height: kMargin50,
                        width: kMargin50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kGreyTextColor,
                          height: kMargin50,
                          width: kMargin50,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kMarginMedium,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userVO.name ?? "",
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: kTextRegular2X,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: kMarginMedium,
                          ),
                          Builder(builder: (context) {
                            return Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              messageVO.getLatestMessage(currentUser?.id ?? ""),
                              style: const TextStyle(
                                  color: kGreyTextColor,
                                  fontWeight: FontWeight.normal),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
