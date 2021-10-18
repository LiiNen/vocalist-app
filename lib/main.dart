import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';

import 'collections/statelessWidget.dart';
import 'collections/function.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashView(),
    );
  }
}

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
    setState(() {
      _isLogin = pref.getBool('isLogin') ?? false;
    });
    navigatorPush(context: context, widget: _isLogin! ? MainNavView() : LoginView(), replacement: true, all: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: MainAppBar(),
        body: Container(
          // child: loginViewButton()
        )
      )
    );
  }

  loginViewButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onTap: () {navigatorPush(context: context, widget: LoginView());},
      onTap: () {navigatorPush(context: context, widget: MainNavView());},
      child: Center(child: Container(
        width: 100, height: 100,
        child: Center(child: Text('login'))
      ))
    );
  }
}

