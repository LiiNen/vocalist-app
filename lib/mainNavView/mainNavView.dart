import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/mainNavView/chartView/chartView.dart';
import 'package:vocalist/mainNavView/homeView/homeView.dart';
import 'package:vocalist/mainNavView/scrapView/scrapView.dart';
import 'package:vocalist/mainNavView/searchView/searchView.dart';
import 'package:vocalist/mainNavView/settingView/settingView.dart';
import 'package:vocalist/popupDialog.dart';
import 'package:vocalist/restApi/noticeApi.dart';

class MainNavView extends StatefulWidget {
  final int selectedIndex;
  final bool notice;
  MainNavView({this.selectedIndex=0, this.notice=false});
  @override
  State<MainNavView> createState() => _MainNavView(selectedIndex, notice);
}
class _MainNavView extends State<MainNavView> {
  int _selectedIndex;
  bool _notice;
  _MainNavView(this._selectedIndex, this._notice);

  List<Widget> _navItemList = <Widget>[
    HomeView(),
    ChartView(),
    ScrapView(),
    SearchView(),
    SettingView()
  ];

  @override
  void initState() {
    super.initState();
    if(_notice) {
      _getNoticeMain();
      _notice = false;
    }
  }

  void _getNoticeMain() async {
    var notice = await getNotice(isMain: true);
    if(notice != null) {
      if(notice.length != 0) {
        final pref = await SharedPreferences.getInstance();
        var _notSeeDate = pref.getString('notSeeNoticeDate') ?? '';
        if(_notSeeDate != getToday()) {
          await showDialog(
            context: context, builder: (context) => PopupDialog(notice: notice[0])
          );
        }
      }
    }
  }

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
          iconSize: 28,
          unselectedFontSize: 12,
          selectedFontSize: 12,
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