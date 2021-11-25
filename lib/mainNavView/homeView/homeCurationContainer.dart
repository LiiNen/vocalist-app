import 'package:flutter/material.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/homeView/recResultView.dart';
import 'package:vocalist/restApi/curationApi.dart';

class HomeCurationContainer extends StatefulWidget {
  final ctype;
  HomeCurationContainer(this.ctype);
  @override
  State<HomeCurationContainer> createState() => _HomeCurationContainer(ctype);
}
class _HomeCurationContainer extends State<HomeCurationContainer> {
  var ctype;
  _HomeCurationContainer(this.ctype);

  var suggestionCurationList = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getCurationSuggestion();
  }

  _getCurationSuggestion() async {
    var temp = await getCurationWithCtype(ctype_id: ctype['id']);
    if(temp != null) {
      setState(() {
        suggestionCurationList = temp;
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 22),
                child: Text('${ctype['title']}', style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 14.0)),
              ),
            ]
          ),
          _isLoaded ? curationScrollView() : Container(),
          lineDivider(context: context, margin: 14)
        ],
      )
    );
  }

  curationScrollView() {
    return Container(
      height: 167,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestionCurationList.length*2+1,
        itemBuilder: (BuildContext context, int index) {
          if(index==0) return SizedBox(width: 12);
          else if(index%2 == 1) return curationContainer(((index-1)/2).floor());
          else return Container(width: 22);
        }
      )
    );
  }

  curationContainer(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigatorPush(context: context, widget: RecResultView(title: '${suggestionCurationList[index]['title']}', curationId: suggestionCurationList[index]['id']));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 40),
        width: 117, height: 117,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          boxShadow: [BoxShadow(
            color: Color(0x29000000),
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 0
          )],
          color: Color(0xffe9e2f5)
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(suggestionCurationList[index]['title']),
              SizedBox(height: 10),
              Text(suggestionCurationList[index]['content'], style: textStyle(size: 12))
            ]
          )
        )
      )
    );
  }
}