import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/playlistItemApi.dart';

class PlayListMusicView extends StatefulWidget {
  final int id;
  final String title;
  final String emoji;
  PlayListMusicView({required this.id, required this.title, required this.emoji});

  @override
  State<PlayListMusicView> createState() => _PlayListMusicView(id, title, emoji);
}
class _PlayListMusicView extends State<PlayListMusicView> {
  int id;
  String title;
  String emoji;
  _PlayListMusicView(this.id, this.title, this.emoji);

  var _musicList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getPlaylist();
  }

  void _getPlaylist() async {
    var _temp = await getPlaylistItem(playlistId: id, userId: userInfo.id, type: 'part');
    setState(() {
      _musicList = _temp;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '플레이리스트 상세', back: true),
      body: isLoaded ? SingleChildScrollView(
        child: Column(
          children: [
            Text(emoji, style: textStyle(size: 110.0)),
            Text(title, style: textStyle(weight: 700, size: 24.0)),
            SizedBox(height: 31),
            Container(margin: EdgeInsets.symmetric(horizontal: 23), child: lineDivider(context: context)),
            MusicListContainer(musicList: _musicList),
          ]
        )
      ) : Container()
    );
  }
}