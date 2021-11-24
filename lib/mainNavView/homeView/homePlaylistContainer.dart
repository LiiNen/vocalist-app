import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/homeView/recResultView.dart';
import 'package:vocalist/restApi/loveApi.dart';

import '../../main.dart';

class HomePlaylistContainer extends StatefulWidget {
  @override
  State<HomePlaylistContainer> createState() => _HomePlaylistContainer();
}
class _HomePlaylistContainer extends State<HomePlaylistContainer> {

  var _likeList = [];
  var _usedIndexList = [];
  var _usedClusterList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getSuggestionPlaylist();
  }

  _getSuggestionPlaylist() async {
    var temp;
    temp = await getLoveList(userId: userInfo.id);
    if(temp != null) {
      temp.shuffle();
      _likeList = temp.toList();
      print(_likeList.length);
      var tempIndex = 0;
      while(true) {
        if(_likeList.length == 0) break;
        if(!_usedClusterList.contains(_likeList[tempIndex]['cluster'])) {
          _usedClusterList.add(_likeList[tempIndex]['cluster']);
          _usedIndexList.add(tempIndex);
        }
        tempIndex++;
        if(_usedIndexList.length == 10 || _likeList.length == tempIndex) break;
      }
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded && _likeList.length != 0 ? Container(
      padding: EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 22, bottom: 14),
                child: Text('나만을 위한 AI 플레이리스트', style: textStyle(weight: 700, size: 14.0)),
              ),
            ]
          ),
          playlistScrollView(),
          Container(
            margin: EdgeInsets.only(top: 40, left: 14, right: 14),
            child: lineDivider(context: context)
          )
        ],
      )
    ) : Container();
  }

  playlistScrollView() {
    return Container(
      height: 226,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _usedIndexList.length*2+1,
        itemBuilder: (BuildContext context, int index) {
          if(index==0) return SizedBox(width: 16);
          else if(index%2 == 1) return playlistContainer(((index-1)/2).floor());
          else return SizedBox(width: 23);
        }
      )
    );
  }

  playlistContainer(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigatorPush(context: context, widget: RecResultView(title: '${_likeList[_usedIndexList[index]]['title']} 연관 음악', cluster: _usedClusterList[index]));
      },
      child: Container(
        width: 219, height: 215,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          boxShadow: [BoxShadow(
            color: Color(0x29000000),
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 0
          )],
          color: Color(0xfff3f5f7)
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subTitleBox('나만의 애창곡'),
              mainTitleBox('MIX ${index+1}'),
              SizedBox(height: 18),
              contentBox('${_likeList[_usedIndexList[index]]['artist']}의 ${_likeList[_usedIndexList[index]]['title']}\n좋아하시는구나?'),
            ]
          )
        )
      )
    );
  }

  subTitleBox(String title) {
    return Text(title, style: textStyle(color: Color(0xff000000), weight: 500, size: 20.0));
  }
  mainTitleBox(String title) {
    return Text(title, style: textStyle(color: Color(0xff000000), weight: 700, size: 25.0));
  }
  contentBox(String content) {
    return Text(content, style: textStyle(color: Color(0xff000000), weight: 500, size: 12.0));
  }
}