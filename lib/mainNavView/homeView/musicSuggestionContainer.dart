import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/homeView/musicSuggestionView.dart';
import 'package:vocalist/music/musicInfoView.dart';
import 'package:vocalist/restApi/musicApi.dart';

class MusicSuggestionContainer extends StatefulWidget {
  final bool isNew;
  MusicSuggestionContainer({this.isNew=false});
  @override
  State<MusicSuggestionContainer> createState() => _MusicSuggestionContainer();
}
class _MusicSuggestionContainer extends State<MusicSuggestionContainer> {

  var _musicList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getMusicSuggestion();
  }

  _getMusicSuggestion() async {
    var temp;
    if(widget.isNew) {
      temp = await getNewMusic(userId: userInfo.id);
    }
    else {
      temp = await getRecMusic(userId: userInfo.id);
      if(temp != null) {
        temp.shuffle();
      }
    }
    if(temp != null) {
      setState(() {
        _musicList = temp.take(30).toList();
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded ? Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.only(top: 22),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(widget.isNew ? 'VLOOM에 추가된 노래' : '이런 노래는 어떠세요?', style: textStyle(weight: 700, size: 14.0)),
              ),
              additionalButton(title: '더보기+', callback: _pushSuggestionView)
            ]
          ),
          suggestionLine(0),
          suggestionLine(1),
          suggestionLine(2),
          SizedBox(height: 22),
          lineDivider(context: context),
        ],
      )
    ) : Container();
  }

  _pushSuggestionView() {
    navigatorPush(context: context, widget: MusicSuggestionView(_musicList, isNew: widget.isNew));
  }

  suggestionLine(int lineIndex) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          suggestionItem(lineIndex*2),
          SizedBox(width: 12),
          suggestionItem(lineIndex*2+1),
        ]
      )
    );
  }

  suggestionItem(int itemIndex) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          navigatorPush(context: context, widget: MusicInfoView(musicId: _musicList[itemIndex]['id'], title: _musicList[itemIndex]['title'], artist: _musicList[itemIndex]['artist']));
        },
        child: Container(
          height: 49,
          padding: EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xfff3f5f7)
          ),
          child: Row(
            children: [
              Text(_musicList[itemIndex]['number'].toString(), style: textStyle(color: Color(0xff4f3497), weight:500, size: 14.0, spacing: -1)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_musicList[itemIndex]['title'], style: textStyle(weight: 500, size: 11.0), overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 3),
                    Text(_musicList[itemIndex]['artist'], style: textStyle(color: Color(0xff747474), weight: 400, size: 10.0), overflow: TextOverflow.ellipsis,)
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}