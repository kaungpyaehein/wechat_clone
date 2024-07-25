import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_clone/data/models/auth_model.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/dimensions.dart';
import 'package:wechat_clone/utils/fonts.dart';

class MyQRPage extends StatefulWidget {
  const MyQRPage({super.key});

  @override
  State<MyQRPage> createState() => _MyQRPageState();
}

class _MyQRPageState extends State<MyQRPage> {
  final AuthModel authModel = AuthModelImpl();
  late UserVO? userVO;
  late String? userId;
  @override
  void initState() {
    userVO = authModel.getUserDataFromDatabase();
    userId = userVO?.id ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        automaticallyImplyLeading: true,
        foregroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          color: kPrimaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My QR",
          style: TextStyle(
              color: kPrimaryColor,
              fontSize: kTextHeading1X,
              fontWeight: FontWeight.w600,
              fontFamily: kYorkieDemo),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMarginMedium3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kMarginXLarge, vertical: kMarginXLarge),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(kMarginMedium2)),
                child: QrImageView(
                  backgroundColor: Colors.white,
                  data: userId ?? "",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
