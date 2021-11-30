import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/loveApi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/restApi/musicApi.dart';

import '../main.dart';

class MusicInfoView extends StatefulWidget {
  final int musicId;
  final String title;
  final String artist;
  MusicInfoView({required this.musicId, required this.title, required this.artist});

  @override
  State<MusicInfoView> createState() => _MusicInfoView(musicId, title, artist);
}
class _MusicInfoView extends State<MusicInfoView> {
  int musicId;
  String title;
  String artist;
  _MusicInfoView(this.musicId, this.title, this.artist);

  dynamic _musicInfo;
  dynamic _clusterMusicList;

  YoutubePlayerController? youtubeController;

  @override
  void initState() {
    super.initState();
    _loadMusicInfo();
  }

  void _loadMusicInfo() async {
    var _temp = await getMusic(id: musicId, userId: userInfo.id);
    if(_temp != null) {
      if(_temp['cluster'] != null) {
        _getClusterMusic(_temp['cluster']);
      }
      setState(() {
        _musicInfo = _temp;
        youtubeController = YoutubePlayerController(
          initialVideoId: _musicInfo['youtube'],
          flags: YoutubePlayerFlags(
            autoPlay: false,
          )
        );
      });
    }
  }

  void _getClusterMusic(cluster) async {
    var temp = await getRecMusicCluster(userId: userInfo.id, cluster: cluster);
    if(temp != null) {
      setState(() {
        _clusterMusicList = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '노래 정보', back: true,),
      body: Column(
        children: [
          youtubeController != null ? youtubeEmbeddedPlayer() : Container(),
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                _musicInfo != null ? musicInfoContainer() : Container(),
                _clusterMusicList != null ? relatedMusicContainer() : Container(),
              ]
            )
          ))
        ]
      )
    );
  }

  youtubeEmbeddedPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: YoutubePlayer(
        controller: youtubeController!,
        bottomActions: [
          SizedBox(width: 14.0),
          CurrentPosition(),
          SizedBox(width: 8.0),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: Color(0xffab9adf),
              handleColor: Color(0xff8b63ff),
            ),
          ),
          RemainingDuration(),
          SizedBox(width: 14.0),
        ],
      )
    );
  }

  musicInfoContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_musicInfo['number'] == null ? '00000' : _musicInfo['number'].toString(),
                style: textStyle(color: Color(0xff3c354d), weight: 700, size: 26.0, spacing: -3)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_musicInfo['title'], style: textStyle(weight: 700, size: 18.0)),
                    Text(_musicInfo['artist'], style: textStyle(weight: 500, size: 14.0))
                  ]
                )
              )
            ]
          ),
          _musicInfo['number'] == null ? SizedBox(height: 12) : Container(),
          _musicInfo['number'] == null ? Text('아직 노래방 번호 데이터가 없는 노래입니다.', style: textStyle(color: Color(0xffd4d4d4), weight: 500, size: 14.0)) : Container(),
          SizedBox(height: 22),
          Row(
            children: [
              actionBox(isLike: _musicInfo['islike']),
              SizedBox(width: 8),
              actionBox()
            ]
          )
        ]
      )
    );
  }

  actionBox({int isLike=-1}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if(isLike != -1) _likeAction();
          else _addPlaylist();
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Color(0xffe6e6e6), width: 1)
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLike != -1 ?
                  Icon(isLike==1 ? Icons.favorite : Icons.favorite_border, color: isLike==1 ? Color(0xffab9adf) : Color(0xffd4d4d4), size: 16,) :
                  Icon(Icons.playlist_add_rounded, color: Color(0xffd4d4d4), size: 16),
                SizedBox(width: 4),
                Text(isLike != -1 ? '좋아요' : '플레이리스트 추가',
                  style: textStyle(
                    color: isLike==1 ? Color(0xffab9adf) : Color(0xffd4d4d4),
                    weight: 600,
                    size: 14.0,
                  )
                )
              ]
            )
          )
        )
      ),
    );
  }

  _likeAction() async {
    bool isResponse;
    if(_musicInfo['islike'] == 0) {
      isResponse = await postLove(musicId: _musicInfo['id'], userId: userInfo.id);
    }
    else {
      isResponse = await deleteLove(musicId: _musicInfo['id'], userId: userInfo.id);
    }
    setState(() {
      if(isResponse) _musicInfo['islike'] = _musicInfo['islike']==0 ? 1 : 0;
      else showToast('네트워크를 확인해주세요.');
    });
  }

  _addPlaylist() {
    var musicObject = Map();
    musicObject['id'] = _musicInfo['id'];
    musicObject['title'] = _musicInfo['title'];
    navigatorPush(context: context, widget: PlayListView(isAdding: true, object: musicObject));
  }

  relatedMusicContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lineDivider(context: context, margin: 16),
          SizedBox(height: 22),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text('vloom이 추천하는 유사한 음악', style: textStyle(weight: 700, size: 16.0))
          ),
          MusicListContainer(musicList: _clusterMusicList)
        ]
      )
    );
  }
}