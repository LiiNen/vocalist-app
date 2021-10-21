import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';
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
      appBar: MainAppBar(title: '좋아요한 노래 목록', back: true),
      body: Container(
        child: Column(
          children: [
            _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList)
          ]
        )
      )
    );
  }
}