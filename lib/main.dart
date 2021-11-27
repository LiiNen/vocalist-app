import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
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
    await Firebase.initializeApp();
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => MainNavView(),
          transitionDuration: Duration.zero,
        ),
      );
    }
    else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginView(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, bottom: 10),
                child: Image.asset('asset/image/logo_50.png', height: 60)
              ),
              Text('음역대 분석 노래방 서비스', style: textStyle(weight: 600, size: 18.0)),
            ]
          )
        )
      )
    );
  }
}

