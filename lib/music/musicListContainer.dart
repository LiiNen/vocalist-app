import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
import 'package:vocalist/mainNavView/searchView/searchResultAllView.dart';
import 'package:vocalist/music/musicInfoView.dart';
import 'package:vocalist/restApi/loveApi.dart';

import '../main.dart';

class MusicListContainer extends StatefulWidget {
  final musicList;
  final String highlight;
  final int index;
  final bool isScrap;
  final bool isSearchAll;
  final bool isFriend;
  MusicListContainer({required this.musicList, this.isScrap=false, this.highlight='', this.index=0, this.isSearchAll=false, this.isFriend=false});

  @override
  State<MusicListContainer> createState() => _MusicListContainer(musicList, isScrap, highlight.toLowerCase(), index, isSearchAll, isFriend);
}
class _MusicListContainer extends State<MusicListContainer> {
  List<dynamic> musicList;
  String highlight;
  int searchIndex;
  bool isScrap;
  bool isSearchAll;
  bool isFriend;
  _MusicListContainer(this.musicList, this.isScrap, this.highlight, this.searchIndex, this.isSearchAll, this.isFriend);

  int pitchValue = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> musicItemContainerList = List.generate(musicList.length, (index) {
      return musicItemContainer(index);
    });
    return Column(
      children: <Widget>[titleBox()] + (
        musicItemContainerList.length != 0 ?
          musicItemContainerList :
          [Text('검색 결과를 찾을 수 없습니다.', style: textStyle(color: Color(0xff7c7c7c), weight: 400, size: 13.0))]
      )
    );
  }

  titleBox() {
    var _title = '';
    if(searchIndex == 0) return Container();
    else {
      if(searchIndex == 1) _title = '곡 제목';
      else if(searchIndex == 2) _title = '가수';
      else if(searchIndex == 3) _title = '큐레이션';
    }
    return Container(
      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_title, style: textStyle(weight: 700, size: 19.0)),
              !isSearchAll ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  navigatorPush(context: context, widget: SearchResultAllView(searchIndex: searchIndex, input: highlight));
                },
                child: Text('더 보기', style: textStyle(color: Color(0xff7156d2), weight: 500, size: 14.0))
              ) : Container()
            ]
          ),
          SizedBox(height: 14),
          lineDivider(context: context, color: Color(0xffa89bda))
        ]
      )
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
            karaokeNumber(_music['number']),
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
      width: 24,
      child: Text((index+1).toString(), style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 17.0, spacing: index+1 >= 100 ? -2.5 : -1), textAlign: TextAlign.center)
    );
  }
  
  karaokeNumber(number) {
    return Container(
      width: 70,
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Center(child: Text(
        number == null ? '00000' : number.toString(),
        style: textStyle(color: Color(0xff3c354d), weight: 700, size: 21.0, spacing: -2)))
    );
  }

  musicInfo(String _title, String _artist) {
    List<TextSpan> textSpanList = [];
    List<Widget> children = [];
    if(searchIndex == 1) {
      var _titleSplit = _title.split(highlight);
      textSpanList = List.generate(_titleSplit.length * 2 - 1, (index) {
        if(index%2 == 0) return TextSpan(text: _titleSplit[(index/2).floor()], style: textStyle(weight: 700, size: 13.0));
        return TextSpan(text: highlight, style: textStyle(color: Color(0xffee806a), weight: 700, size: 13.0));
      });

      children = [
        RichText(text: TextSpan(children: textSpanList), overflow: TextOverflow.ellipsis),
        Text('$_artist', style: textStyle(weight: 500, size: 10.0), overflow: TextOverflow.ellipsis)
      ];
    }
    else if(searchIndex == 2) {
      var _artistSplit = _artist.split(highlight);
      textSpanList = List.generate(_artistSplit.length * 2 - 1, (index) {
        if(index%2 == 0) return TextSpan(text: _artistSplit[(index/2).floor()], style: textStyle(color: Color(0xff747474), weight: 500, size: 10.0));
        return TextSpan(text: highlight, style: textStyle(color: Color(0xffee806a), weight: 500, size: 10.0));
      });

      children = [
        Text('$_title', style: textStyle(weight: 700, size: 13.0), overflow: TextOverflow.ellipsis),
        RichText(text: TextSpan(children: textSpanList), overflow: TextOverflow.ellipsis)
      ];
    }
    else {
      children = [
        Text('$_title', style: textStyle(weight: 700, size: 13.0), overflow: TextOverflow.ellipsis),
        Text('$_artist', style: textStyle(weight: 500, size: 10.0), overflow: TextOverflow.ellipsis)
      ];
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
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
    pitchValue = musicList[index]['pitch'];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                              child: Container(
                                width: 40,
                                child: Center(
                                  child: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff7c7c7c), size: 24)
                                ),
                              )
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Text('음정메모', style: textStyle(color: Color(0xff7156d2), weight: 700, size: 18.0), textAlign: TextAlign.center,),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (isFriend==false) {
                                  patchPitch(userId: userInfo.id, musicId: musicList[index]['id'], pitch: pitchValue);
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 40, padding:EdgeInsets.symmetric(vertical: 16),
                                child: isFriend ? Container() : Text('완료', style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 12.0), textAlign: TextAlign.center,),
                              )
                            ),
                          ]
                        ),
                        isFriend ?
                          Text('친구가 메모해놓은 음정(key)을 보고\n같이 노래방에 갈 때 참고해봐요!', style: textStyle(weight: 400, size: 12.0), textAlign: TextAlign.center,) :
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
                              Text(musicList[index]['number'] != null ? musicList[index]['number'].toString() : '00000', style: textStyle(weight: 700, size: 21.0),),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(musicList[index]['title'], style: textStyle(weight: 700, size: 13.0)),
                                  Text(musicList[index]['artist'], style: textStyle(weight: 500, size: 10.0))
                                ]
                              )
                            ]
                          ),
                          SizedBox(height: 21),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 47),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width, height: 3,
                                  decoration: BoxDecoration(color: Color(0xffee806a),),
                                ),
                                Row(
                                  children: [
                                    pitchCircle(-2, index, setState),
                                    Expanded(child: Container()),
                                    pitchCircle(-1, index, setState),
                                    Expanded(child: Container()),
                                    pitchCircle(0, index, setState),
                                    Expanded(child: Container()),
                                    pitchCircle(1, index, setState),
                                    Expanded(child: Container()),
                                    pitchCircle(2, index, setState),
                                  ]
                                )
                              ]
                            )
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
    );
  }

  pitchCircle(int pitch, int index, StateSetter setState) {
    String pitchString;
    if(pitch == 0) {
      pitchString = '\u00b10';
    }
    else if(pitch > 0) {
      pitchString = '+$pitch';
    }
    else {
      pitchString = '$pitch';
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(isFriend == false) {
          setState(() {
            pitchValue = pitch;
            musicList[index]['pitch'] = pitch;
          });
        }
      },
      child: Column(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.5),
              border: Border.all(
                color: Color(0xffd10000),
                width: 1
              ),
              color: Color(0xfff5f5f5)
            ),
            child: pitchValue == pitch ? Center(
              child: Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.5),
                  color: Color(0xffee806a)
                ),
              )
            ) : Container()
          ),
          SizedBox(height: 3),
          Container(
            height: 17,
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: pitchString,
                    style: textStyle(weight: 500, size: 12.0)
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0, -6),
                      child: Text(
                        'key',
                        textScaleFactor: 0.8,
                        style: textStyle(weight: 500, size: 10.0)
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        ]
      )
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
          child: Icon(isLike==1 ? Icons.favorite : Icons.favorite_border, color: isLike==1 ? Color(0xffab9adf) : Color(0xffd4d4d4))
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
          child: Icon(isScrap ? Icons.more_vert_outlined : Icons.playlist_add_rounded, color: Color(0xffd4d4d4), size: 32.4)
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
                  Text(musicList[index]['number'] != null ? musicList[index]['number'].toString() : '00000', style: textStyle(weight: 700, size: 21.0)),
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
              isFriend ? Container() : modalBox(0, index),
              modalBox(1, index),
            ]
          )
        );
      }
    );
  }

  modalBox(int index, int musicIndex) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if(index == 0) {
            _reloadList(musicIndex);
          }
          else {
            _addPlaylist(musicIndex);
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
    var musicObject = Map();
    musicObject['id'] = musicList[index]['id'];
    musicObject['title'] = musicList[index]['title'];
    navigatorPush(context: context, widget: PlayListView(isAdding: true, object: musicObject));
  }
}
