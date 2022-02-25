import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/settingView/noticeView.dart';
import 'package:vocalist/restApi/noticeApi.dart';

class NoticeListView extends StatefulWidget {
  @override
  State<NoticeListView> createState() => _NoticeListView();
}
class _NoticeListView extends State<NoticeListView> {
  var noticeList = [];

  @override
  void initState() {
    super.initState();
    _getNotice();
  }

  _getNotice() async {
    var temp = await getNotice();
    if(temp != null) {
      setState(() {
        noticeList = temp;
      });
    }
    else {
      showToast('네트워크를 확인해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: '공지사항', back: true),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (noticeList.length > 0 ? List<Widget>.generate(noticeList.length * 2 - 1, (index) {
              if(index%2 != 0) return lineDivider(context: context);
              var _index = (index/2).floor();
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  navigatorPush(context: context, widget: NoticeView(noticeList[_index]));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(noticeList[_index]['title'], style: textStyle(weight: 700, size: 13.0)),
                            Text('작성일 ' + noticeList[_index]['date'], style: textStyle(color: Color(0xff7c7c7c), weight: 500, size: 10.0)),
                          ]
                        )
                      ),
                      openButton(noticeList[_index]['is_open'] == 1)
                    ]
                  )
                )
              );
            }) : <Widget>[]) + [SizedBox(height: 30)]
          )
        )
      )
    );
  }

  openButton(isOpen) {
    return Container(
      width: 48, height: 21,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff8b63ff), width: 1),
        color: !isOpen ? Color(0xff8b63ff) : Colors.white,
      ),
      child: Center(child: Text(isOpen ? 'open' : 'closed', style: textStyle(color: !isOpen ? Colors.white : Color(0xff8b63ff), weight: 500, size: 10.0), textAlign: TextAlign.center))
    );
  }
}