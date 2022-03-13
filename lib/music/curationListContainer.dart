import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/homeView/recResultView.dart';
import 'package:vocalist/restApi/restApi.dart';

class CurationListContainer extends StatefulWidget {
  final curationList;
  CurationListContainer({required this.curationList});

  @override
  State<CurationListContainer> createState() => _CurationListContainer(curationList);
}

class _CurationListContainer extends State<CurationListContainer> {
  List<dynamic> curationList;
  _CurationListContainer(this.curationList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleBox(),
        curationScrollView()
      ]
    );
  }

  titleBox() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('큐레이션', style: textStyle(weight: 700, size: 19.0)),
          SizedBox(height: 14),
          lineDivider(context: context, color: Color(0xffa89bda)),
        ]
      )
    );
  }

  curationScrollView() {
    return Container(
      height: 139,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: curationList.length*2+1,
        itemBuilder: (BuildContext context, int index) {
          if(index==0) return SizedBox(width: 12);
          else if(index%2 == 1) return curationContainer(((index-1)/2).floor());
          else return Container(width: 22);
        }
      )
    );
  }

  curationContainer(int index) {
    var _item = curationList[index];
    var _imgId = _item['img_id'] != null ? _item['img_id'] : _item['id'];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigatorPush(context: context, widget: RecResultView(title: '${_item['title']}', curationId: _item['id'], curationContent: _item['content']));
      },
      child: Container(
        margin: EdgeInsets.only(top: 22),
        width: 117, height: 117,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('$curationImageUrlStart$_imgId$curationImageUrlEnd'),
            fit: BoxFit.fill
          ),
          borderRadius: BorderRadius.all(Radius.circular(23)),
          boxShadow: [BoxShadow(
            color: Color(0x29000000),
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 0
          )],
          color: Color(0xffe9e2f5)
        ),
      )
    );
  }
}