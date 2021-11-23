import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/scrapView/addPlaylistView.dart';
import 'package:vocalist/mainNavView/scrapView/playListMusicView.dart';
import 'package:vocalist/mainNavView/searchView/searchResultView.dart';
import 'package:vocalist/restApi/playlistApi.dart';
import 'package:vocalist/restApi/playlistItemApi.dart';

class PlayListView extends StatefulWidget {
  final bool isAdding;
  final dynamic object;
  PlayListView({this.isAdding=false, this.object});
  @override
  State<PlayListView> createState() => _PlayListView(isAdding, object);
}
class _PlayListView extends State<PlayListView> {
  bool isAdding;
  dynamic object;
  _PlayListView(this.isAdding, this.object);

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
          margin: EdgeInsets.symmetric(horizontal: 29, vertical: 5),
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
        onTap: () {
          if(isAdding) {
            addMusicDialog(musicTitle: object!['title'], playlistTitle: playlistItem['title'], firstAction: () {_addMusicToPlaylist(object['id'], playlistItem['id']);}, secondAction: () {_cancel(context);});
          }
          if(!isAdding) {
            navigatorPush(context: context, widget: PlayListMusicView(title: playlistItem['title'], id: playlistItem['id'], emoji: playlistItem['emoji']));
          }
        },
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
                  child: playlistItem['emoji'] == '' ? Container() : Text(unicodeToEmoji(playlistItem['emoji']), style: textStyle(size: 22.0))
                )
              ),
              SizedBox(width: 25),
              Expanded(
                child: Container(
                  child: Text(playlistItem['title'], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 20.0), overflow: TextOverflow.ellipsis,)
                )
              ),
              Container(
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

  Future<bool> addMusicDialog({required String musicTitle, required String playlistTitle, required firstAction, required secondAction}) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: musicTitle, style: textStyle(color: Color(0xff433e57), weight: 700, size: 14.0)),
              TextSpan(text: ' 를\n', style: textStyle(color: Color(0xff707070), weight: 500, size: 14.0)),
              TextSpan(text: playlistTitle, style: textStyle(color: Color(0xff433e57), weight: 700, size: 14.0)),
              TextSpan(text: ' 플레이리스트에 추가하겠습니까?', style: textStyle(color: Color(0xff707070), weight: 500, size: 14.0)),
            ]
          )
        ),
        actions: [
          TextButton(
            onPressed: firstAction,
            child: Text('예', style: textStyle(color: Color(0xff7156d2), weight: 500, size: 14.0)),
          ),
          TextButton(
            onPressed: secondAction,
            child: Text('아니요', style: textStyle(color: Color(0xff707070), weight: 500, size: 14.0)),
          ),
        ],
      ),
    )) ?? false;
  }

  _addMusicToPlaylist(musicId, playlistId) async {
    var response = await postPlaylistItem(playlistId: playlistId, musicId: musicId);
    if(response) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else {
      showToast('error');
    }
  }

  _cancel(context) {
    Navigator.pop(context);
  }
}