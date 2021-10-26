import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/scrapView/likeListView.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
import 'package:vocalist/restApi/friendApi.dart';
import 'package:vocalist/restApi/loveApi.dart';
import 'package:vocalist/restApi/playlistApi.dart';

class ScrapView extends StatefulWidget {
  @override
  State<ScrapView> createState() => _ScrapView();
}
class _ScrapView extends State<ScrapView> {
  var _menuObjectList = [
    {
      'title': '좋아요한 노래',
      'count': -1,
      'route': '/likeList'
    },
    {
      'title': '저장한 플레이리스트',
      'count': -1,
      'route': '/playList'
    }
  ];
  var _friendList = [];

  @override
  void initState() {
    super.initState();
    _getCount();
    _getFriend();
  }

  _getCount() async {
    var _likeTemp = await getLoveCount(userId: userInfo.id);
    var _playTemp = await getPlaylistCount(userId: userInfo.id);
    setState(() {
      _menuObjectList[0]['count'] = _likeTemp['count'];
      _menuObjectList[1]['count'] = _playTemp['count'];
    });
  }
  
  _getFriend() async {
    var _temp = await getFriend(userId: userInfo.id);
    setState(() {
      _friendList = _temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '보관함'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              menuButton(0),
              menuButton(1),
              friendContainer()
            ]
          )
        )
      )
    );
  }

  menuButton(int index) {
    var _menuObject = _menuObjectList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {Navigator.pushNamed(context, _menuObject['route'].toString());},
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.white
        ),
        child: _menuObject['count'] != -1 ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_menuObject['title'].toString(), style: textStyle(size: 16.0)),
            Text(_menuObject['count'].toString(), style: textStyle(size: 16.0))
          ]
        ) : Container()
      )
    );
  }

  /// HACK
  friendContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 36),
      padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('친구 플레이리스트', style: textStyle(size: 16.0)),
              Icon(Icons.add_box_outlined, size: 20)
            ]
          ),
          SizedBox(height: 18),
        ] + List.generate(_friendList.length, (index) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_friendList[index]['name']),
                SizedBox(height: 14),
              ]
            )
          );
        })
      )
    );
  }

}