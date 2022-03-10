import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/homeView/recResultView.dart';
import 'package:vocalist/restApi/musicApi.dart';
import 'package:vocalist/restApi/restApi.dart';

import '../../main.dart';

class HomePlaylistContainer extends StatefulWidget {
  @override
  State<HomePlaylistContainer> createState() => _HomePlaylistContainer();
}
class _HomePlaylistContainer extends State<HomePlaylistContainer> {

  var _likeArtistList = [];
  var _recNumber;
  bool isLoaded = false;

  var suggestionSentence = [
    '좋아하시는구나?',
    '좋아하는 당신을 위해!',
    '그리고 vloom의 선택',
    '그렇다면 이건 어때요?',
    '관련 음악 둘러보기'
  ];

  var imageList = List.generate(10, (index) {
    return '$mixImageUrlStart${index+1}$mixImageUrlEnd';
  });

  @override
  void initState() {
    super.initState();
    _getSuggestionPlaylist();
  }

  _getSuggestionPlaylist() async {
    var temp = await getRecArtist(userId: userInfo.id);
    if(temp != null) {
      temp.shuffle();
      suggestionSentence.shuffle();
      imageList.shuffle();
      _likeArtistList = temp.toList();
      _recNumber = min(_likeArtistList.length, 10);
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded && _likeArtistList.length != 0 ? Container(
      padding: EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 22),
                child: Text('나만을 위한 AI 플레이리스트', style: textStyle(weight: 700, size: 14.0)),
              ),
            ]
          ),
          playlistScrollView(),
          // lineDivider(context: context, margin: 14)
        ],
      )
    ) : Container();
  }

  playlistScrollView() {
    return Container(
      height: 269,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recNumber*2+1,
        itemBuilder: (BuildContext context, int index) {
          if(index==0) return SizedBox(width: 16);
          else if(index%2 == 1) return playlistContainer(((index-1)/2).floor());
          else return SizedBox(width: 23);
        }
      )
    );
  }

  playlistContainer(int index) {
    var artistName = _likeArtistList[index]['artist'];
    var _contain = Random().nextInt(2) == 0 && !artistName.contains('(');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _contain ?
          navigatorPush(context: context, widget: RecResultView(title: '$artistName이(가) 참여한 노래', artist: artistName, contain: 1)) :
          navigatorPush(context: context, widget: RecResultView(title: '$artistName의 노래', artist: artistName, contain: 0));
      },
      child: Container(
        margin: EdgeInsets.only(top: 14, bottom: 22),
        width: 219, height: 215,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageList[index]),
            fit: BoxFit.fill
          ),
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
              _contain ? contentBox('$artistName이(가) 참여한 노래') : contentBox('$artistName의 노래'),
              suggestionBox('${suggestionSentence[index%5]}'),
            ]
          )
        )
      )
    );
  }

  subTitleBox(String title) {
    return Text(title, style: textStyle(color: Colors.white, weight: 500, size: 20.0));
  }
  mainTitleBox(String title) {
    return Text(title, style: textStyle(color: Colors.white, weight: 700, size: 25.0));
  }
  contentBox(String content) {
    return Text(content, style: textStyle(color: Colors.white, weight: 500, size: 12.0), overflow: TextOverflow.ellipsis,);
  }
  suggestionBox(String suggestion) {
    return Text(suggestion, style: textStyle(color: Colors.white, weight: 500, size: 12.0));
  }
}