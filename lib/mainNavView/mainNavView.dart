import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/mainNavView/chartView/chartView.dart';
import 'package:vocalist/mainNavView/homeView/homeView.dart';
import 'package:vocalist/mainNavView/scrapView/scrapView.dart';
import 'package:vocalist/mainNavView/searchView/searchView.dart';
import 'package:vocalist/mainNavView/settingView/settingView.dart';

class MainNavView extends StatefulWidget {
  @override
  State<MainNavView> createState() => _MainNavView();
}
class _MainNavView extends State<MainNavView> {
  int _selectedIndex = 0;

  List<Widget> _navItemList = <Widget>[
    HomeView(),
    ChartView(),
    ScrapView(),
    SearchView(),
    SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _navItemList.elementAt(_selectedIndex)
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: '인기차트', icon: Icon(Icons.star)),
            BottomNavigationBarItem(label: '보관함', icon: Icon(Icons.bookmark)),
            BottomNavigationBarItem(label: '검색하기', icon: Icon(Icons.search)),
            BottomNavigationBarItem(label: '더보기', icon: Icon(Icons.more_horiz))
          ]
        ),
      )
    );
  }
}