import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/collections/userInfo.dart';

import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';

import 'collections/statelessWidget.dart';
import 'collections/function.dart';
import 'mainNavView/scrapView/likeListView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginView(),
        '/mainNav': (context) => MainNavView(),
        '/search': (context) => MainNavView(selectedIndex: 3),
        '/likeList': (context) => LikeListView(),
        '/playList': (context) => PlayListView(),
        '/setting': (context) => MainNavView(selectedIndex: 4),
      },
      home: SplashView(),
    );
  }
}

late UserInfo userInfo;

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashView();
}
class _SplashView extends State<SplashView> {

  bool? _isLogin;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 1), _checkLogin);
  }

  void _checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    _isLogin = pref.getBool('isLogin') ?? false;
    if(_isLogin == true) {
      userInfo = await getUserInfo();
      setState(() {
        print(userInfo.id);
        print(userInfo.name);
        print(userInfo.email);
        print(userInfo.type);
      });
      Navigator.pushReplacementNamed(context, '/mainNav');
    }
    else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Shader linearGradientShader = ui.Gradient.linear(Offset(0, 20), Offset(270, 0), [Colors.purple.shade600, Colors.red.shade200]);
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('asset/image/splashImage.png', width: 88),
              SizedBox(height: 25),
              Text('BLOOMING\nYOUR VOICE', style: TextStyle(foreground: Paint()..shader = linearGradientShader, fontSize: 22, fontWeight: FontWeight.w700,), textAlign: TextAlign.center),
              SizedBox(height: 120)
            ]
          )
        )
      )
    );
  }
}

