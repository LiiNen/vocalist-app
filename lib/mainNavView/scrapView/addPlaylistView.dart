import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/mainNavView.dart';
import 'package:vocalist/mainNavView/scrapView/playListView.dart';
import 'package:vocalist/restApi/playlistApi.dart';

class AddPlaylistView extends StatefulWidget {
  @override
  State<AddPlaylistView> createState() => _AddPlaylistView();
}
class _AddPlaylistView extends State<AddPlaylistView> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        appBar: MainAppBar(title: '플레이리스트 추가', back: true),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                playlistTitleContainer(),
                confirmButton(),
              ]
            )
          )
        )
      )
    );
  }

  playlistTitleContainer() {
    return TextField(
      controller: _controller,

    );
  }

  confirmButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if(_controller.text != '') _confirmAction();
        else {
          showToast('플레이리스트 제목을 입력해주세요');
        }
      },
      child: Container(
        child: Center(
          child: Text('확인')
        )
      )
    );
  }

  _confirmAction() async {
    print(_controller.text);
    postPlaylist(userId: userInfo.id, title: _controller.text);
    Navigator.pushNamedAndRemoveUntil(context, '/playList', ModalRoute.withName('/mainNav'));
  }
}