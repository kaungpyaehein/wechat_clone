import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wechat_clone/data/models/auth_model_impl.dart';
import 'package:wechat_clone/data/vos/user_vo.dart';
import 'package:wechat_clone/firebase_options.dart';
import 'package:wechat_clone/pages/auth/upload_profile_page.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/pages/auth/splash_page.dart';
import 'package:wechat_clone/utils/fonts.dart';

import 'persistence/hive_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Initialize hive
  await Hive.initFlutter();

  /// Register adapters
  Hive.registerAdapter(UserVOAdapter());

  /// Open Hive Box
  await Hive.openBox<UserVO>(kBoxNameUserVO);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _authModel = AuthModelImpl();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: kNotoSans,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white,
              foregroundColor: Colors.white)),
      // home: UploadProfilePage(
      //   userVO: UserVO(),
      // )
      home: (_authModel.isLoggedIn()) ? const HomePage() : const SplashPage(),
    );
  }
}
