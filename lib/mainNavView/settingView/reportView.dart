import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
      child: Scaffold(
        appBar: MainAppBar(title: '버그 리포트', back: true),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('hello'),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '제목'
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: '내용'
                    ),
                  ),
                  Text('연락받으실 이메일을 입력해주세요'),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: userInfo.email
                    ),
                  ),
                ]
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _sendReport();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: 80, height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: Center(child: Text('작성 완료'))
                )
              )
            )
          ]
        )
      )
    );
  }

  _sendReport() async {
    var _email = _emailController.text == '' ? userInfo.email : _emailController.text;
    var result = await postBugReport(userId: userInfo.id, title: _titleController.text, content: _contentController.text, email: _email);
    if(result == null) {
      print('error occur');
    }
    else {
      showToast('버그리포트가 정상적으로 접수되었습니다.');
      Navigator.pop(context);
    }
  }
}