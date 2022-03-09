import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/emojiPickerWidget.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/playlistApi.dart';
import 'package:vocalist/restApi/playlistItemApi.dart';

class PlayListMusicView extends StatefulWidget {
  final int id;
  final String title;
  final String emoji;
  final dynamic backCallback;
  PlayListMusicView({required this.id, required this.title, required this.emoji, this.backCallback});

  @override
  State<PlayListMusicView> createState() => _PlayListMusicView(id, title, emoji);
}
class _PlayListMusicView extends State<PlayListMusicView> {
  int id;
  String title;
  String emoji;
  _PlayListMusicView(this.id, this.title, this.emoji);

  var _musicList = [];
  bool _isLoaded = false;
  bool _isEditing = false;

  TextEditingController _controller = TextEditingController();
  TextEditingController _emojiController = TextEditingController();
  bool isEmojiFocused = false;

  @override
  void initState() {
    super.initState();
    _getPlaylistItem();
  }

  void _getPlaylistItem() async {
    var _temp = await getPlaylistItem(playlistId: id, userId: userInfo.id, type: 'part');
    setState(() {
      _musicList = _temp;
      _isLoaded = true;
      _emojiController.text = emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {isEmojiFocused = false;});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(title: '플레이리스트 상세', back: true, actionButton: _editButton(), backCallback: widget.backCallback),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
          children: [
            _isLoaded ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: (!_isEditing ? <Widget>[
                  Text(emoji, style: textStyle(size: 110.0)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(title, style: textStyle(weight: 700, size: 24.0), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                  )
                ] : <Widget>[
                  editEmojiContainer(),
                  editTitleContainer(),
                ]) + [
                  SizedBox(height: 31),
                  Container(margin: EdgeInsets.symmetric(horizontal: 23), child: lineDivider(context: context)),
                  MusicListContainer(musicList: _musicList, isPlaylist: true, callback: _removePlaylistItemCallback, isPlaylistEditing: _isEditing, backCallback: widget.backCallback),
                ]
              )
            ) : Container(),
            isEmojiFocused ? Positioned(
              bottom: 0,
              child: _emojiPicker()
            ) : Container()
          ]
        )
      ))
    );
  }

  _editButton() {
    return Container(
      width: 32, height: 32,
      child: Center(
        child: additionalButton(title: !_isEditing ? '편집' : '완료', callback: _setPlaylistEditing, isOpposite: !_isEditing, width: 32.0)
      )
    );
  }

  _setPlaylistEditing() async {
    if(_isEditing) {
      var _titleChanged = _controller.text != title;
      var _emojiChanged = _emojiController.text != emoji;
      if(_titleChanged || _emojiChanged) {
        var _response = await patchPlaylist(id: id, title: _titleChanged ? _controller.text : title, emoji: _emojiChanged ? _emojiController.text : emoji);
        if(_response != null) {
          showToast('변경사항 저장 완료');
        }
        else {
          showToast('네트워크 에러');
        }
      }
      _getPlaylist();
    }
    setState(() {
      _isEditing = !_isEditing;
      if(_isEditing == false) {
        _isLoaded = false;
      }
    });
  }

  editEmojiContainer() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isEmojiFocused = true;
        });
      },
      child: Text(_emojiController.text, style: textStyle(size: 110))
    );
  }

  editTitleContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: textStyle(color: Color(0xffb9b9b9), weight: 600, size: 24.0),
        ),
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {FocusManager.instance.primaryFocus?.unfocus();},
        style: textStyle(weight: 700, size: 24.0),
        textAlign: TextAlign.center,
      )
    );
  }
  _emojiPicker() {
    return EmojiPickerWidget(
      onEmojiSelected: (String emoji) {
        setState(() {
          _emojiController.text = emoji;
        });
      }
    );
  }

  void _removePlaylistItemCallback({required int musicId, required String musicTitle}) async {
    await removePlaylistItemDialog(musicId: musicId, musicTitle: musicTitle);
  }

  Future<bool> removePlaylistItemDialog({required musicId, required String musicTitle}) async {
    return (await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: '',
        positiveAction: () {_removePlaylistItem(musicId);},
        negativeAction: () {Navigator.pop(context);},
        positiveWord: '확인',
        negativeWord: '취소',
        spanTitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: musicTitle, style: textStyle(color: Color(0xff433e57), weight: 700, size: 14.0)),
              TextSpan(text: ' 를\n', style: textStyle(color: Color(0xff707070), weight: 500, size: 14.0)),
              TextSpan(text: emoji, style: textStyle(color: Color(0xff433e57), weight: 700, size: 14.0)),
              TextSpan(text: ' $title', style: textStyle(color: Color(0xff433e57), weight: 700, size: 14.0)),
              TextSpan(text: ' 플레이리스트에서 제거하시겠습니까?', style: textStyle(color: Color(0xff707070), weight: 500, size: 14.0)),
            ]
          )
        ),
      ),
    )) ?? false;
  }

  void _removePlaylistItem(musicId) async {
    var response = await deletePlaylistItem(playlistId: id, musicId: musicId);
    if(response != null) {
      showToast('성공적으로 제거되었습니다.');
      setState(() {
        isLoaded = false;
      });
    }
    _getPlaylistItem();
  }
}