import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/restApi/userApi.dart';

import '../../emojiPickerWidget.dart';

class NameModifyView extends StatefulWidget {
  @override
  State<NameModifyView> createState() => _NameModifyView();
}
class _NameModifyView extends State<NameModifyView> {
  TextEditingController _emojiController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isEmojiFocused = false;

  @override
  void initState() {
    super.initState();
    _emojiController.text = unicodeToEmoji(userInfo.emoji);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {isEmojiFocused = false;});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(title: '프로필 설정', back: true),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  SizedBox(height: 39),
                  setEmojiContainer(),
                  SizedBox(height: 33),
                  _nameContainer(),
                  SizedBox(height: 82),
                  confirmButton(confirmAction: () {_confirmAction();}),
                  Expanded(child: Container()),
                ]
              )
            ),
            isEmojiFocused ? Positioned(
              bottom: 20,
              child: _emojiPicker()
            ) : Container()
          ]
        )
      )
    );
  }

  setEmojiContainer() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _showEmojiPicker();
      },
      child: Container(
        width: 170, height: 170,
        child: Stack(
          children: [
            Container(
              width: 170, height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(85)),
                border: Border.all(color: Color(0xfff0f0f0), width: 1),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _emojiController,
                enabled: false,
                style: textStyle(size: 100.0),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                )
              )
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

  _emojiPicker() {
    return EmojiPickerWidget(
      onEmojiSelected: (String emoji) {
        setState(() {
          _emojiController.text = emoji;
        });
      }
    );
  }

  _showEmojiPicker() {
    setState(() {isEmojiFocused = true;});
  }

  _nameContainer() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: userInfo.name,
        hintStyle: textStyle(color: Color(0xffb9b9b9), weight: 500, size: 12.0),
        suffixIcon: _nameController.text != '' ? IconButton(
          iconSize: 20,
          alignment: Alignment.centerRight,
          onPressed: () => {setState(() {_nameController.clear();})},
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

  _confirmAction() async {
    await patchUser(id: userInfo.id, name: _nameController.text != '' ? _nameController.text : userInfo.name, emoji: emojiToUnicode(_emojiController.text));
    Navigator.pushNamedAndRemoveUntil(context, '/setting', ModalRoute.withName('/'));
  }
}