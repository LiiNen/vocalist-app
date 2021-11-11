import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/music/musicInfoView.dart';
import 'package:vocalist/restApi/loveApi.dart';

import '../main.dart';

class MusicListContainer extends StatefulWidget {
  final musicList;
  final bool isScrap;
  MusicListContainer({required this.musicList, this.isScrap=false});

  @override
  State<MusicListContainer> createState() => _MusicListContainer(musicList, isScrap);
}
class _MusicListContainer extends State<MusicListContainer> {
  var musicList;
  bool isScrap;
  _MusicListContainer(this.musicList, this.isScrap);

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
            isScrap ? pitchBox(index) : likeBox(index, _music['islike']),
            playlistBox(index),
          ]
        )
      )
    );
  }
  
  indexBox(index) {
    return Container(
      width: 16,
      child: Text((index+1).toString(), style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 17.0), textAlign: TextAlign.center)
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
      onTap: () {
        _pitchModal(index);
      },
      child: Container(
        child: Center(
          child: Icon(Icons.music_note_outlined, color: Color(0xffe4e4e4), size: 28.4)
        )
      )
    );
  }

  _pitchModal(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 272,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(0xfff0f0f0),
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {Navigator.pop(context);},
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff7c7c7c), size: 24),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: Text('음정메모', style: textStyle(color: Color(0xff7156d2), weight: 700, size: 18.0), textAlign: TextAlign.center,),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {Navigator.pop(context);},
                          child: Container(
                            width: 24,
                            child: Text('완료', style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 12.0), textAlign: TextAlign.center,),
                          )
                        ),
                      ]
                    ),
                    Text('이 노래를 부를 때, ${userInfo.name}님이 부르기 편한\n음정(key)을 메모해보세요!', style: textStyle(weight: 400, size: 12.0), textAlign: TextAlign.center,),
                    SizedBox(height: 20),
                  ]
                )
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('00000', style: textStyle(weight: 700, size: 21.0),),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(musicList[index]['title'], style: textStyle(weight: 700, size: 13.0)),
                              Text(musicList[index]['artist'], style: textStyle(weight: 500, size: 10.0))
                            ]
                          ),
                          SizedBox(height: 12),
                        ]
                      )
                    ]
                  )
                )
              )
            ]
          )
        );
      }
    );
  }

  likeBox(int index, int isLike) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        likeAction(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Icon(isLike==1 ? Icons.favorite : Icons.favorite_border)
        )
      )
    );
  }

  likeAction(index) async {
    bool isResponse;
    if(musicList[index]['islike'] == 0) {
      isResponse = await postLove(musicId: musicList[index]['id'], userId: userInfo.id);
    }
    else {
      isResponse = await deleteLove(musicId: musicList[index]['id'], userId: userInfo.id);
    }
    setState(() {
      if(isResponse) musicList[index]['islike'] = musicList[index]['islike']==0 ? 1 : 0;
      else showToast('네트워크를 확인해주세요.');
    });
  }

  playlistBox(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(isScrap) _scrapModal(index);
        else _addPlaylist(index);
      },
      child: Container(
        child: Center(
          child: Icon(isScrap ? Icons.more_vert_outlined : Icons.playlist_add_rounded, color: Color(0xffe4e4e4), size: 32.4)
        )
      )
    );
  }

  _scrapModal(index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 21, horizontal: 24),
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {Navigator.pop(context);},
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                  ),
                  SizedBox(width: 15),
                  Text('00000', style: textStyle(weight: 700, size: 21.0)),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(musicList[index]['title'], style: textStyle(weight: 700, size: 13.0)),
                      Text(musicList[index]['artist'], style: textStyle(weight: 500, size: 10.0)),
                    ]
                  )
                ]
              ),
              SizedBox(height: 21),
              lineDivider(context: context),
              SizedBox(height: 12),
              modalBox(0),
              modalBox(1),
            ]
          )
        );
      }
    );
  }

  modalBox(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if(index == 0) {
            _reloadList(index);
          }
          else {
            _addPlaylist(index);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Text(index == 0 ? '좋아요 해제' : '플레이리스트 추가', style: textStyle(color: Color(0xff7c7c7c), weight: 400, size: 14.0))
      )
    );
  }

  _reloadList(index) async {
    var response = await deleteLove(musicId: musicList[index]['id'], userId: userInfo.id);
    if(response) {
      var temp = await getLoveList(userId: userInfo.id);
      setState(() {
        if(temp != null) musicList = temp;
      });
    }
  }

  _addPlaylist(index) {

  }
}