import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';

List<bool> checkList = [false, false, false];

showSignUpConfirmDialog(BuildContext context) async {
  bool response = false;
  checkList = [false, false, false];
  var dialogState = await showDialog(
    context: context,
    builder: (context) {
      return SignUpConfirmDialog();
    }
  ).then((exit) {
    if(exit != null) {
      if(exit == true) {
        response = true;
      }
      else response = false;
    }
    else response = false;
  });
  return response;
}

class SignUpConfirmDialog extends StatefulWidget {
  @override
  State<SignUpConfirmDialog> createState() => _SignUpConfirmDialog();
}
class _SignUpConfirmDialog extends State<SignUpConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: policyBox()
    );
  }

  policyBox() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              child: Image.asset('asset/image/logo_50.png', height: 38)
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'vloom 서비스 이용을 위해서는\n'
              '아래 약관의 동의가 필요합니다.',
              style: textStyle(color: Color(0xff707070), weight: 400, size: 16.0),
              textAlign: TextAlign.left,
            ),
          ),
          _checkBoxRow(0, '모두 동의합니다.', false, textStyle(weight: 600, size: 18.0)),
          lineDivider(context: context, margin: 12.0),
          _checkBoxRow(1, '(필수) 서비스 이용 약관', true, textStyle(color: Color(0xff707070), weight: 400, size: 14.0)),
          lineDivider(context: context, margin: 12.0),
          _checkBoxRow(2, '(필수) 개인정보 수집 및 이용 동의', true, textStyle(color: Color(0xff707070), weight: 400, size: 14.0)),
          Container(
            height: 52,
            child: Row(
              children: [
                confirmBox()
              ]
            )
          )
        ]
      )
    );
  }

  _checkBoxRow(int index, String title, bool detailBool, TextStyle style) {
    return GestureDetector(
      onTap: () => {_checkBoxTap(index)},
      child: Container(
        height: 24,
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                checkList[index] ? Icon(Icons.check_box_rounded, color: Color(0xff7156d2)) : Icon(Icons.check_box_outline_blank_rounded, color: Color(0xff707070)),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: Text(title, style: style,),
                ),
              ]
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => {print('hello')},
              child: Container(
                width: 24, height: 24,
                child: detailBool ? Icon(Icons.arrow_forward_ios, color: Color(0xff707070), size: 16) : Container()
              )
            ),
          ],
        )
      )
    );
  }

  void _checkBoxTap(index) {
    setState(() {
      if(index == 0) {
        checkList[0] = checkList[1] = checkList[2] = (_check() ? false : true);
      }
      else {
        checkList[index] = !checkList[index];
        if(checkList[0] && !checkList[index]) checkList[0] = false;
        if(_check()) checkList[0] = true;
      }
    });
  }

  bool _check() {
    return (checkList[1] && checkList[2] ? true : false);
  }

  confirmBox() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if(checkList[0] == true) Navigator.pop(context, true);
          else {
            showToast('모든 약관에 동의해주세요.');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffebebeb), width: 1),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
            color: Color(0xfffbfbfb),
          ),
          child: Center(
            child: Text('회원가입', style: textStyle(color: checkList[0] ? Color(0xff7156d2) : Color(0xff707070), weight: 600, size: 14.0))
          )
        )
      )
    );
  }
}