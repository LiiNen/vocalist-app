import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/scrapView/likeListView.dart';
import 'package:vocalist/restApi/friendApi.dart';
import 'package:vocalist/restApi/loveApi.dart';
import 'package:vocalist/restApi/playlistApi.dart';

class ScrapView extends StatefulWidget {
  @override
  State<ScrapView> createState() => _ScrapView();
}
class _ScrapView extends State<ScrapView> {
  var _menuObjectList = [
    {
      'title': '좋아요한 노래',
      'count': -1,
      'route': '/likeList'
    },
    {
      'title': '저장한 플레이리스트',
      'count': -1,
      'route': '/playList'
    }
  ];
  var _friendList = [];
  var _friendWaitingList = [];
  TextEditingController _friendEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCount();
    _getFriend();
  }

  _getCount() async {
    var _likeTemp = await getLoveCount(userId: userInfo.id);
    var _playTemp = await getPlaylistCount(userId: userInfo.id);
    setState(() {
      _menuObjectList[0]['count'] = _likeTemp['count'];
      _menuObjectList[1]['count'] = _playTemp['count'];
    });
  }
  
  _getFriend() async {
    _friendList = [];
    _friendWaitingList = [];
    var _temp = await getFriend(userId: userInfo.id);
    for(var _friend in _temp) {
      if(_friend['accept'] == 0 && _friend['applier'] == 0) {
        _friendWaitingList.add(_friend);
      }
      else if(_friend['accept'] == 1) {
        _friendList.add(_friend);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: '애창곡 보관함'),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 18),
              menuButton(0),
              menuButton(1),
              friendContainer(),
              friendWaitingContainer(),
            ]
          )
        )
      )
    );
  }

  menuButton(int index) {
    var _menuObject = _menuObjectList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {Navigator.pushNamed(context, _menuObject['route'].toString());},
      child: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xfff0f0f0)
        ),
        child: _menuObject['count'] != -1 ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_menuObject['title'].toString(), style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 16.0)),
            Row(
              children: [
                Text(_menuObject['count'].toString(), style: textStyle(color: Color(0xffd1d1d1), weight: 700, size: 14.0)),
                SizedBox(width: 4.3),
                // todo: arrow right button
              ]
            )
          ]
        ) : Container()
      )
    );
  }

  /// HACK
  friendContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Color(0xffdddddd), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('친구 애창곡 보기', style: textStyle(color: Color(0xff5642a0), weight: 700, size: 14.0)),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _showFriendDialog,
                child: Icon(Icons.person_add_outlined, size: 22, color: Color(0xff7c7c7c))
              )
            ]
          ),
          SizedBox(height: 16),
        ] + List.generate(_friendList.length * 2, (index) {
          if(index%2 == 0) return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {navigatorPush(context: context, widget: LikeListView(friendId: _friendList[(index/2).floor()]['friend_id'], friendName: _friendList[(index/2).floor()]['name']));},
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_friendList[(index/2).floor()]['name'], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 12.0)),
                ]
              )
            )
          );
          else return SizedBox(height: 16);
        })
      )
    );
  }

  friendWaitingContainer() {
    return _friendWaitingList.length != 0 ? Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Color(0xffdddddd), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('대기 중인 친구 목록', style: textStyle(color: Color(0xff5642a0), weight: 700, size: 14.0)),
            ]
          ),
          SizedBox(height: 16),
        ] + List.generate(_friendWaitingList.length * 2, (index) {
          if(index%2 == 0) return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _friendAcceptDialog(name:_friendWaitingList[(index/2).floor()]['name'], id: _friendWaitingList[(index/2).floor()]['id']);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_friendWaitingList[(index/2).floor()]['name'], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 12.0)),
                ]
              )
            )
          );
          else return SizedBox(height: 16);
        })
      )
    ) : Container();
  }

  _showFriendDialog() async {
    return (await showDialog(
      context: context,
      builder: (context) => _addFriendDialog()
    )) ?? false;
  }

  _addFriendDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 112,
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: TextField(
                  controller: _friendEmailController,
                  decoration: InputDecoration(
                    hintText: '친구의 이메일을 입력해주세요'
                  ),
                  onChanged: (value) {setState(() {});},
                  onSubmitted: (value) {
                    _addFriendAction();
                    Navigator.pop(context);
                  }
                )
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _addFriendAction();
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffebebeb), width: 1),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                          color: Color(0xfffbfbfb),
                        ),
                        child: Center(
                          child: Text('친구 요청', style: textStyle(color: Color(0xff0958c5), weight: 600, size: 14.0))
                        )
                      )
                    )
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }

  _addFriendAction() async {
    var response = await postFriend(userId: userInfo.id, email: _friendEmailController.text);
    if(response == true) {
      _getFriend();
      showToast('친구 요청 완료!');
    }
  }

  _friendAcceptDialog({required String name, required int id}) {
    showConfirmDialog(context, ConfirmDialog(
      title: '$name님의 친구요청을 수락하시겠습니까?',
      positiveAction: () {_friendAction(true, id);},
      negativeAction: () {_friendAction(false, id);},
      confirmAction: null,
      positiveWord: '수락',
      negativeWord: '거절'
    ));
  }
  _friendAction(bool state, int id) {
    state ? _friendAcceptAsync(id) : _friendDenyAsync(id);
  }
  _friendAcceptAsync(int id) async {
    var response = await patchFriend(id: id);
    if(response) {
      _getFriend();
    }
  }
  _friendDenyAsync(int id) async {
    var response = await deleteFriend(id: id);
    if(response) {
      _getFriend();
    }
  }
}