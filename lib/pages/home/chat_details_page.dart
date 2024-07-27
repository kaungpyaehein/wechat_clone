import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:wechat_clone/blocs/chat_details_bloc.dart';
import 'package:wechat_clone/data/vos/message_vo.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/route_extensions.dart';

import '../../data/vos/user_vo.dart';

GlobalKey<FormState> chatFormKey = GlobalKey();

class ChatDetailsPage extends StatefulWidget {
  const ChatDetailsPage({super.key, required this.userToChat});
  final UserVO userToChat;

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatDetailsBloc(widget.userToChat),
      child: Builder(builder: (context) {
        final bloc = context.read<ChatDetailsBloc>();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: const BackButton(
              color: kPrimaryColor,
            ),
            centerTitle: false,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(kMarginXLarge2),
                  child: Image.network(
                    widget.userToChat.profileImage ?? "",
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
                Text(
                  widget.userToChat.name ?? "",
                  style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: kTextRegular2X,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              StreamBuilder(
                  stream: bloc.getMessagesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.connectionState != ConnectionState.waiting &&
                        snapshot.data != null) {
                      final List<MessageVO> messages = snapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final MessageVO message = messages[index];
                          final bool isCurrentUser =
                              (message.senderId == widget.userToChat.id);
                          if (message.imageUrl?.isEmpty ?? false) {
                            return TextMessageView(
                              messageVO: message,
                              isCurrentUser: isCurrentUser,
                            );
                          }
                          return ImageMessageView(
                            messageVO: message,
                            isCurrentUser: isCurrentUser,
                          );
                        },
                      );
                    }

                    return const Center(
                      child: Text("empty messages"),
                    );
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Form(
                    key: chatFormKey,
                    child: TextFormField(
                      controller: messageInputController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: kGreyTextColor),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kMarginSmall),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kMarginSmall),
                            borderSide: BorderSide.none),
                        isDense: true, // Added this
                        contentPadding: const EdgeInsets.all(kMarginMedium),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: kPrimaryColor,
                            size: kMarginXLarge,
                          ),
                          onPressed: () {
                            bloc.handleSendPressed(messageInputController.text);

                            messageInputController.clear();
                          },
                        ),
                        prefixIcon: IconButton(
                          onPressed: () {
                            bloc.sendPhotoMessage();
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: kPrimaryColor,
                            size: kMarginXLarge,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        bloc.handleSendPressed(messageInputController.text);
                        messageInputController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    super.key,
    required this.messageVO,
    required this.isCurrentUser,
  });

  final MessageVO messageVO;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          right: kMarginMedium3,
          left: kMarginMedium3,
          top: kMarginMedium2,
          bottom: kMarginMedium2),
      child: Align(
        alignment: (isCurrentUser ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kMargin5),
            color: (isCurrentUser ? kPrimaryColor : Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                textAlign: TextAlign.start,
                messageVO.text ?? "",
                style: TextStyle(
                    fontSize: kText15,
                    color: isCurrentUser ? Colors.white : kPrimaryColor),
              ),
              const SizedBox(
                height: kMarginMedium,
              ),
              Text(
                messageVO.getFormattedTime(),
                style: TextStyle(
                    color: isCurrentUser ? Colors.white : kPrimaryColor,
                    fontSize: kMarginMedium),
                textAlign: TextAlign.end,
                softWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    super.key,
    required this.messageVO,
    required this.isCurrentUser,
  });

  final MessageVO messageVO;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (isCurrentUser ? Alignment.topLeft : Alignment.topRight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {
              context.push(PhotoViewWidget(imageUrl: messageVO.imageUrl ?? ""));
            },
            child: CachedNetworkImage(
              imageUrl: messageVO.imageUrl ?? "",
              fit: BoxFit.cover,
              height: 160,
              width: 250,
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoViewWidget extends StatelessWidget {
  const PhotoViewWidget({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          imageUrl,
        ),
        errorBuilder: (context, error, stackTrace) => Container(
          color: kGreyTextColor,
        ),
        loadingBuilder: (context, event) => Container(
          color: kGreyTextColor,
        ),
      ),
    );
  }
}
