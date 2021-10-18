import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/mainNavView/scrapView/likeListView.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
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
      'widget': LikeListView()
    },
    {
      'title': '저장한 플레이리스트',
      'count': -1,
      'widget': PlayListView()
    }
  ];

  @override
  void initState() {
    super.initState();
    _getCount();
  }

  _getCount() async {
    var _likeTemp = await getLoveCount(userId: 1);
    var _playTemp = await getPlaylistCount(userId: 1);
    setState(() {
      _menuObjectList[0]['count'] = _likeTemp['count'];
      _menuObjectList[1]['count'] = _playTemp['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '보관함'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 21),
        child: SingleChildScrollView(
          child: Column(
            children: [
              menuButton(0),
              menuButton(1)
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
      onTap: () {navigatorPush(context: context, widget: _menuObject['widget']);},
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white
        ),
        child: _menuObject['count'] != -1 ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_menuObject['title'].toString()),
            Text(_menuObject['count'].toString())
          ]
        ) : Container()
      )
    );
  }

}