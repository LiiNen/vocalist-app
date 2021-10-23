import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        '/likeList': (context) => LikeListView(),
        '/playList': (context) => PlayListView()
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
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: MainAppBar(),
        body: Container(
          child: Center(
            child: FlutterLogo(size: 30),
          )
        )
      )
    );
  }
}

