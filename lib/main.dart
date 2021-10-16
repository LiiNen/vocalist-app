import 'package:flutter/material.dart';

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
      home: InitialView(),
    );
  }
}

class InitialView extends StatefulWidget {
  @override
  State<InitialView> createState() => _InitialView();
}
class _InitialView extends State<InitialView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: MainAppBar(),
        body: Container(
          child: loginViewButton()
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

