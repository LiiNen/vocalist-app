import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class HomePlaylistContainer extends StatefulWidget {
  @override
  State<HomePlaylistContainer> createState() => _HomePlaylistContainer();
}
class _HomePlaylistContainer extends State<HomePlaylistContainer> {

  var suggestionPlaylist = ['', '', ''];

  @override
  void initState() {
    super.initState();
    _getSuggestionPlaylist();
  }

  _getSuggestionPlaylist() async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  playlistScrollView() {
    return Container(
      height: 226,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestionPlaylist.length*2+1,
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
      onTap: () {},
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
            children: [
              subTitleBox(''),
              mainTitleBox(''),
              SizedBox(height: 18),
              contentBox(''),
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