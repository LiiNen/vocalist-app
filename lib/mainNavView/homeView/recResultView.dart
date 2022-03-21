import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/curationItemApi.dart';
import 'package:vocalist/restApi/musicApi.dart';
import 'package:vocalist/restApi/playlistApi.dart';

import '../../main.dart';

class RecResultView extends StatefulWidget {
  final String title;
  final String artist;
  final int contain;
  final int curationId;
  final String curationContent;
  RecResultView({required this.title, this.artist='', this.contain=-1, this.curationId=-1, this.curationContent=''});

  @override
  State<RecResultView> createState() => _RecResultView(title, artist, contain, curationId, curationContent);
}
class _RecResultView extends State<RecResultView> {
  String title;
  String artist;
  int contain;
  int curationId;
  String curationContent;
  _RecResultView(this.title, this.artist, this.contain, this.curationId, this.curationContent);

  var _musicList = [];
  var _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if(contain != -1) _getRecMusicArtist(artist, contain);
    if(curationId != -1) _getRecMusicCuration();
  }

  void _getRecMusicArtist(artist, contain) async {
    var temp = await getRecMusicArtist(userId: userInfo.id, artist: artist, contain: contain);
    if(temp != null) {
      setState(() {
        if(contain == 0) {
          _musicList = temp;
        }
        else if(contain == 1) {
          _musicList = temp;
        }
        _isLoaded = true;
      });
    }
  }

  _getRecMusicCuration() async {
    var temp = await getCurationItem(userId: userInfo.id, curationId: curationId);
    if(temp != null) {
      _musicList = temp;
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: title, back: true),
      body: _isLoaded ? SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              curationContent != '' ? curationContentBox() : Container(),
              MusicListContainer(musicList: _musicList)
            ]
          )
        )
      ) : Container()
    );
  }

  curationContentBox() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, top: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(curationContent, style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 14.0)),
              additionalButton(title: '플레이리스트에 추가', width: 100.0, isOpposite: true, callback: exportPlaylist)
            ]
          ),
          SizedBox(height: 15),
          lineDivider(context: context),
        ]
      )
    );
  }

  exportPlaylist() async {
    var _temp = await postPlaylistFromCuration(userId: userInfo.id, curationId: curationId);
    if(_temp != null) showToast('플레이리스트 추가 완료!');
    else showToast('네트워크를 확인해주세요');
  }
}