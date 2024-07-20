import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home/home_page.dart';
import 'package:wechat_clone/pages/auth/splash_page.dart';
import 'package:wechat_clone/utils/colors.dart';
import 'package:wechat_clone/utils/fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          foregroundColor: Colors.white
        )
      ),
      home: const SplashPage(),
    );
  }
}
