import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/mainNavView/chartView/chartView.dart';
import 'package:vocalist/mainNavView/homeView/homeView.dart';
import 'package:vocalist/mainNavView/scrapView/scrapView.dart';
import 'package:vocalist/mainNavView/searchView/searchView.dart';
import 'package:vocalist/mainNavView/settingView/settingView.dart';

class MainNavView extends StatefulWidget {
  final int selectedIndex;
  MainNavView({this.selectedIndex=0});
  @override
  State<MainNavView> createState() => _MainNavView(selectedIndex);
}
class _MainNavView extends State<MainNavView> {
  int _selectedIndex = 0;
  _MainNavView(this._selectedIndex);

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
          backgroundColor: Colors.white,
          unselectedItemColor: Color(0xffd4d4d4),
          selectedItemColor: Color(0xff3c354d),
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home_outlined)),
            BottomNavigationBarItem(label: '인기차트', icon: Icon(Icons.star_outline_rounded)),
            BottomNavigationBarItem(label: '보관함', icon: Icon(Icons.bookmark_outline_rounded)),
            BottomNavigationBarItem(label: '검색하기', icon: Icon(Icons.search_outlined)),
            BottomNavigationBarItem(label: '더보기', icon: Icon(Icons.more_horiz_outlined))
          ]
        ),
      )
    );
  }
}