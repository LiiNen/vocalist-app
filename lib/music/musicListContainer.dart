import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/music/musicInfoView.dart';
import 'package:vocalist/restApi/loveApi.dart';

class MusicListContainer extends StatefulWidget {
  final musicList;
  MusicListContainer({required this.musicList});

  @override
  State<MusicListContainer> createState() => _MusicListContainer(musicList);
}
class _MusicListContainer extends State<MusicListContainer> {
  var musicList;
  _MusicListContainer(this.musicList);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: List.generate(musicList.length, (index) {
          return musicItemContainer(index);
        })
      )
    );
  }

  musicItemContainer(int index) {
    var _music = musicList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {navigatorPush(context: context, widget: MusicInfoView(musicId: _music['id'],));},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            karaokeNumber(),
            musicInfo(_music['title'], _music['artist']),
            likeBox(index, _music['islike']),
            playlistBox(_music['id']),
          ]
        )
      )
    );
  }

  karaokeNumber() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Center(child: Text('000000'))
    );
  }

  musicInfo(String _title, String _artist) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_title),
          Text(_artist),
        ]
      )
    );
  }

  likeBox(int index, int isLike) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(musicList[index]['islike'] == 0) {
          postLove(musicId: musicList[index]['id'], userId: 1);
        }
        else {
          deleteLove(musicId: musicList[index]['id'], userId: 1);
        }
        setState(() {
          musicList[index]['islike'] = musicList[index]['islike']==0 ? 1 : 0;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Icon(isLike==1 ? Icons.favorite : Icons.favorite_border)
        )
      )
    );
  }

  playlistBox(int id) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {

      },
      child: Container(
        child: Center(
          child: Icon(Icons.playlist_add_rounded)
        )
      )
    );
  }
}