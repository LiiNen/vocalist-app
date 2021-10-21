import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/playlistItemApi.dart';

class PlayListMusicView extends StatefulWidget {
  final int id;
  final String title;
  PlayListMusicView({required this.id, required this.title});

  @override
  State<PlayListMusicView> createState() => _PlayListMusicView(id, title);
}
class _PlayListMusicView extends State<PlayListMusicView> {
  int id;
  String title;
  _PlayListMusicView(this.id, this.title);

  var _musicList = [];

  @override
  void initState() {
    super.initState();
    _getPlaylist();
  }

  void _getPlaylist() async {
    var _temp = await getPlaylistItem(playlistId: id, userId: userInfo.id, type: 'part');
    setState(() {
      _musicList = _temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: title, back: true),
      body: Container(
        child: Column(
          children: [
            _musicList.length == 0 ? Container() : MusicListContainer(musicList: _musicList)
          ]
        )
      )
    );
  }
}