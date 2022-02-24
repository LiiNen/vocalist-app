import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/restApi/bugReportApi.dart';

import '../../main.dart';

class ReportView extends StatefulWidget {
  @override
  State<ReportView> createState() => _ReportView();
}
class _ReportView extends State<ReportView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(title: '버그 리포트', back: true),
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 28),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9),
                    _titleBox('제목'),
                    Container(
                      height: 30,
                      child: textField(controller: _titleController, focusNode: _titleFocusNode, hint: '', nextFocusNode: _contentFocusNode)
                    ),
                    _titleBox('내용'),
                    textField(controller: _contentController, focusNode: _contentFocusNode, hint: '', allowEnter: true),
                    _titleBox('연락받을 이메일'),
                    Container(
                      height: 30,
                      child: textField(controller: _emailController, focusNode: _emailFocusNode, hint: userInfo.email),
                    ),
                    _titleBox('개인정보 수집 및 이용'),
                    _collectBox()
                  ]
                ),
              ),
              Column(
                children: [
                  bottomAlignButton(title: '버그 리포트 보내기', callback: _sendReport),
                  SizedBox(height: 32),
                ]
              )
            ]
          )
        )
      )
    );
  }

  _titleBox(String title) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 8),
      child: Text(title, style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 12.0))
    );
  }

  _collectBox() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 16, height: 16,
            margin: EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: _isChecked ? Color(0xff8b63ff) : Color(0xffefefef)
            ),
            child: _isChecked ? Center(child: Icon(Icons.check, color: Colors.white, size: 16)) : Container(),
          ),
          Text('개인정보 수집 및 이용 동의 (필수)', style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 12.0))
        ]
      )
    );
  }

  _sendReport() async {
    var _email = _emailController.text == '' ? userInfo.email : _emailController.text;
    var result = await postBugReport(userId: userInfo.id, title: _titleController.text, content: _contentController.text, email: _email);
    if(result == null) {
      // error
    }
    else {
      showToast('버그리포트가 정상적으로 접수되었습니다.');
      Navigator.pop(context);
    }
  }
}