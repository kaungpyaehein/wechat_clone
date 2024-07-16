import 'package:flutter/material.dart';
import 'package:wechat_clone/pages/home_page.dart';
import 'package:wechat_clone/pages/splash_page.dart';
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
        fontFamily: kNotoSans,
      ),
      home: const SplashPage(),
    );
  }
}
