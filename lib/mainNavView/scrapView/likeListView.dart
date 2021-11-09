import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/loveApi.dart';

class LikeListView extends StatefulWidget {
  @override
  State<LikeListView> createState() => _LikeListView();
}
class _LikeListView extends State<LikeListView> {

  var _likeList = [];

  @override
  void initState() {
    super.initState();
    _getLikeList();
  }
  void _getLikeList() async {
    var temp = await getLoveList(userId: userInfo.id);
    setState(() {
      _likeList = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: '좋아요한 노래 목록', back: true),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            descriptionBox(),
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList),
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList),
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList),
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList),
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList),
          ]
        )
      )
    );
  }

  descriptionBox() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, top: 21),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('해당 리스트를 바탕으로\n음역대에 알맞은 노래를 추천해드려요!', style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 10.0)),
              modifyButton(),
            ]
          ),
          SizedBox(height: 15),
          lineDivider(context: context),
        ]
      )
    );
  }

  modifyButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //todo : modifying action
      },
      child: Container(
        width: 48, height: 21,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          color: Color(0xfff6c873),
        ),
        child: Center(child: Text('편집', style: textStyle(weight: 500, size: 10.0)))
      )
    );
  }
}