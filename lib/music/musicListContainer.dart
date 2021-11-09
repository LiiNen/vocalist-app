import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
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
    return Column(
      children: List.generate(musicList.length, (index) {
        return musicItemContainer(index);
      })
    );
  }

  musicItemContainer(int index) {
    var _music = musicList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {navigatorPush(context: context, widget: MusicInfoView(musicId: _music['id'],));},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width, height: 68,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            indexBox(index),
            karaokeNumber(),
            musicInfo(_music['title'], _music['artist']),
            // likeBox(index, _music['islike']),
            pitchBox(index),
            playlistBox(_music['id']),
          ]
        )
      )
    );
  }
  
  indexBox(index) {
    return Container(
      width: 16,
      child: Text(index.toString(), style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 17.0), textAlign: TextAlign.center)
    );
  }
  
  karaokeNumber() {
    return Container(
      margin: EdgeInsets.only(left: 21, right: 15),
      child: Center(child: Text('00000', style: textStyle(color: Color(0xff3c354d), weight: 700, size: 21.0)))
    );
  }

  musicInfo(String _title, String _artist) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_title, style: textStyle(weight: 700, size: 13.0)),
          Text(_artist, style: textStyle(weight: 500, size: 10.0)),
        ]
      )
    );
  }

  pitchBox(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
        child: Center(
          child: Icon(Icons.music_note_outlined, color: Color(0xffe4e4e4), size: 28.4)
        )
      )
    );
  }

  likeBox(int index, int isLike) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {

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
          child: Icon(Icons.more_vert_outlined, color: Color(0xffe4e4e4), size: 32.4)
        )
      )
    );
  }

  likeAction(index) {
    if(musicList[index]['islike'] == 0) {
      postLove(musicId: musicList[index]['id'], userId: 1);
    }
    else {
      deleteLove(musicId: musicList[index]['id'], userId: 1);
    }
    setState(() {
      musicList[index]['islike'] = musicList[index]['islike']==0 ? 1 : 0;
    });
  }
}