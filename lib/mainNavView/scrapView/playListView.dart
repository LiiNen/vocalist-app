import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/mainNavView/scrapView/addPlaylistView.dart';
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
    var _temp = await getPlaylist(userId: 1);
    setState(() {
      _playlist = _temp;
      print(_playlist);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _scrollableList = [addPlaylistButton()];
    if(_playlist != []) _scrollableList = _scrollableList + List.generate(_playlist.length, (index) {
      return playlistContainer(_playlist[index]);
    });

    return Scaffold(
      appBar: MainAppBar(title: '내 플레이리스트', back: true),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 21),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: _scrollableList
          )
        )
      )
    );
  }
  
  addPlaylistButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {navigatorPush(context: context, widget: AddPlaylistView());},
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 20,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Center(
                child: Icon(Icons.playlist_add_rounded)
              )
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('플레이리스트 추가')
                )
              )
            )
          ]
        )
      )
    );
  }

  playlistContainer(playlistItem) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {navigatorPush(context: context, widget: SearchResultView(type: '', input: ''));},
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 20,
              child: Center(
                child: Icon(Icons.star)
              )
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(playlistItem['title']),
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(playlistItem['count'].toString()),
                Icon(Icons.arrow_forward_ios_outlined)
              ]
            )
          ]
        )
      )
    );
  }
}