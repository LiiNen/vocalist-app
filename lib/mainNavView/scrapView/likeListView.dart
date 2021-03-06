import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/loveApi.dart';

class LikeListView extends StatefulWidget {
  final int friendId;
  final String friendName;
  final dynamic backCallback;
  LikeListView({this.friendId=-1, this.friendName='', this.backCallback});
  @override
  State<LikeListView> createState() => _LikeListView(friendId, friendName);
}
class _LikeListView extends State<LikeListView> {
  int friendId;
  String friendName;
  _LikeListView(this.friendId, this.friendName);

  var _likeList = [];
  bool _isLoaded = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _getLikeList();
  }
  void _getLikeList() async {
    if(friendId == -1) {
      var temp = await getLoveList(userId: userInfo.id);
      if(temp != null) {
        setState(() {
          _likeList = temp;
          _isLoaded = true;
        });
      }
    }
    else {
      var temp = await getLoveList(userId: friendId);
      if(temp != null) {
        setState(() {
          _likeList = temp;
          _isLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: friendName!='' ? '$friendName님의 애창곡' : '좋아요한 노래 목록', back: true, backCallback: widget.backCallback),
      backgroundColor: Colors.white,
      body: _isLoaded ? _likeList.length == 0 ?
        Column(
          children: [
            descriptionBox(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('asset/image/icoFail.svg', width: 28, height: 48),
                  SizedBox(height: 24),
                  Text('좋아요한 노래가 없습니다.', style: textStyle(color: Color(0xff7c7c7c), weight: 600, size: 16.0),),
                  SizedBox(height: 60),
                ]
              )
            )
          ]
        ) :
        SingleChildScrollView(
          child: Column(
            children: [
              descriptionBox(),
              _likeList.length == 0 ? Container() : MusicListContainer(musicList: _likeList, isScrap: true, isFriend: friendId != -1, isEditing: _isEditing)
            ]
          )
        ) : Container()
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
              Text(
                friendId == -1
                  ? '해당 리스트를 바탕으로\n음역대에 알맞은 노래를 추천해드려요!'
                  : '친구의 좋아요 목록을 확인하고\n같이 노래방에 가서 불러봐요!',
                style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 10.0)
              ),
              friendId == -1 ? additionalButton(title: friendId == -1 ? !_isEditing ? '편집' : '완료' : '공유', callback: friendId == -1 ? setEditing : null, isOpposite: friendId == -1 ? !_isEditing : false) : Container(),
            ]
          ),
          SizedBox(height: 15),
          lineDivider(context: context),
        ]
      )
    );
  }

  setEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if(_isEditing == false) {
        _isLoaded = false;
      }
      _getLikeList();
    });
  }
}