import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/scrapView/addPlaylistView.dart';
import 'package:vocalist/mainNavView/scrapView/playListMusicView.dart';
import 'package:vocalist/mainNavView/searchView/searchResultView.dart';
import 'package:vocalist/restApi/playlistApi.dart';

class PlayListView extends StatefulWidget {
  @override
  State<PlayListView> createState() => _PlayListView();
}
class _PlayListView extends State<PlayListView> {
  var _playlist = [];

  @override
  void initState() {
    super.initState();
    _getPlaylist();
  }

  void _getPlaylist() async {
    var _temp = await getPlaylist(userId: userInfo.id);
    setState(() {
      _playlist = _temp;
      print(_playlist);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _scrollableList = [
      addPlaylistButton(context),
      SizedBox(height: 6),
      lineDivider(context: context),
      SizedBox(height: 30),
    ];
    if(_playlist != []) _scrollableList = _scrollableList + List.generate(_playlist.length, (index) {
      return playlistContainer(_playlist[index], context);
    });

    return Scaffold(
      appBar: DefaultAppBar(title: '저장한 플레이리스트', back: true),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 21, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: _scrollableList
          )
        )
      )
    );
  }
  
  addPlaylistButton(context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {navigatorPush(context: context, widget: AddPlaylistView());},
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Color(0xfff6c873),
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Center(
                child: Icon(Icons.playlist_add_rounded, color: Color(0xff3c354d), size: 24)
              )
            ),
            SizedBox(width: 25),
            Container(
              child: Text('플레이리스트 생성', style: textStyle(weight: 500, size: 20.0))
            )
          ]
        )
      )
    );
  }

  playlistContainer(playlistItem, context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {navigatorPush(context: context, widget: PlayListMusicView(title: playlistItem['title'], id: playlistItem['id']));},
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Color(0xfff3f5f7),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Center(
                  child: Icon(Icons.star)
                )
              ),
              SizedBox(width: 25),
              Expanded(
                child: Container(
                  child: Text(playlistItem['title'], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 20.0))
                )
              ),
              Container(
                width: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(playlistItem['count'].toString(), style: textStyle(color: Color(0xffcecece), weight: 500, size: 20.0)),
                    Icon(Icons.arrow_forward_ios_outlined, color: Color(0xffcecece))
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}