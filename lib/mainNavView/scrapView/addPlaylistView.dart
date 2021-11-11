import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/emojiPickerWidget.dart';
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
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(title: '플레이리스트 생성', back: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 57),
                      setEmojiContainer(),
                      SizedBox(height: 33),
                      playlistTitleContainer(),
                      SizedBox(height: 16),
                      addMusicButton(),
                      SizedBox(height: 46),
                      confirmButton(),
                    ]
                  )
                ),
                Align(
                  widthFactor: 1.0, heightFactor: 1.0,
                  alignment: Alignment.bottomCenter,
                  child: _emojiPicker()
                )
              ]
            )
          )
        )
      )
    );
  }

  setEmojiContainer() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _showEmojiPicker();
      },
      child: Container(
        width: 170, height: 170,
        child: Stack(
          children: [
            Container(
              width: 170, height: 170,
              decoration: BoxDecoration(
                color: Color(0xfff0f0f0),
                borderRadius: BorderRadius.all(Radius.circular(85)),
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Color(0xff4a4a4a),
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                ),
                child: Center(
                  child: Icon(Icons.create_outlined, size: 25, color: Colors.white),
                )
              )
            )
          ]
        )

      )
    );
  }

  playlistTitleContainer() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: '플레이리스트 제목 입력',
        hintStyle: textStyle(color: Color(0xffb9b9b9), weight: 500, size: 12.0),
        suffixIcon: _controller.text != '' ? IconButton(
          iconSize: 20,
          alignment: Alignment.centerRight,
          onPressed: () => {setState(() {_controller.clear();})},
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.clear_rounded, color: Color(0xffb9b9b9))
        ) : null,
      ),
      onChanged: (value) {
        setState(() {});
      },
      onSubmitted: (value) {_confirmAction();},
      style: textStyle(weight: 500, size: 12.0)
    );
  }

  addMusicButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Text('+ 곡 추가하기', style: textStyle(color: Color(0xff7156d2), weight: 500, size: 14.0))
      )
    );
  }

  confirmButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _confirmAction();
      },
      child: Container(
        width: 62, height: 29,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(26)),
          color: Color(0xfff6c873),
        ),
        child: Center(
          child: Text('완료', style: textStyle(weight: 500, size: 12.0))
        )
      )
    );
  }

  _confirmAction() async {
    if(_controller.text != '') {
      postPlaylist(userId: userInfo.id, title: _controller.text);
      Navigator.pushNamedAndRemoveUntil(context, '/playList', ModalRoute.withName('/mainNav'));
    }
    else {
      showToast('플레이리스트 제목을 입력해주세요');
    }
  }

  _emojiPicker() {
    return EmojiPickerWidget(
      onEmojiSelected: (String emoji) {
        setState(() {
          _controller.text = emoji;
        });
      }
    );
  }

  _showEmojiPicker() {

  }
}