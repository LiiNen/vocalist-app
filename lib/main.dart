import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/collections/userInfo.dart';

import 'package:vocalist/loginView/loginView.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
import 'package:vocalist/restApi/versionApi.dart';

import 'collections/function.dart';
import 'mainNavView/scrapView/likeListView.dart';

bool isDevMode = true;
bool isAdIgnore = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  // initAdMobRewarded();
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
    _checkUpdate();
    setAdIgnore();
  }

  void _checkUpdate() async {
    var _isUpdating = await getUpdate();
    if(_isUpdating['build'] == '0') {
      new Future.delayed(new Duration(seconds: 1), _checkLogin);
    }
    else {
      await popUpdate(context);
      exit(0);
    }
  }

  void _checkLogin() async {
    // await Firebase.initializeApp();
    final pref = await SharedPreferences.getInstance();
    _isLogin = pref.getBool('isLogin') ?? false;
    if(_isLogin == true) {
      userInfo = await getUserInfo();
      setState(() {});
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => MainNavView(notice: true,),
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
    return PopScope(
      onPopInvoked: (dipPop) {
        onWillPop(context);
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, bottom: 10),
                child: Image.asset('asset/image/splashLogo.png', height: 60)
              ),
              Text('노래방 필수 어플리케이션', style: textStyle(weight: 600, size: 18.0)),
            ]
          )
        )
      )
    );
  }
}

