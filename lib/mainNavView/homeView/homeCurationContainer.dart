import 'package:flutter/material.dart';
import 'package:vocalist/collections/style.dart';

class HomeCurationContainer extends StatefulWidget {
  final int typeIndex;
  HomeCurationContainer(this.typeIndex);
  @override
  State<HomeCurationContainer> createState() => _HomeCurationContainer(typeIndex);
}
class _HomeCurationContainer extends State<HomeCurationContainer> {
  int typeIndex;
  _HomeCurationContainer(this.typeIndex);

  var suggestionCurationList = ['', '', '', '', ''];

  @override
  void initState() {
    super.initState();
    _getCurationSuggestion();
  }

  _getCurationSuggestion() async {

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
                margin: EdgeInsets.only(left: 22, bottom: 10),
                child: Text('${curationType[typeIndex]}큐레이션', style: textStyle(color: Color(0xff7c7c7c), weight: 700, size: 14.0)),
              ),
            ]
          ),
          curationScrollView(),
          Container(
            margin: EdgeInsets.only(top: 40, left: 14, right: 14),
            child: lineDivider(context: context)
          )
        ],
      )
    );
  }

  curationScrollView() {
    return Container(
      height: 128,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestionCurationList.length*2+1,
        itemBuilder: (BuildContext context, int index) {
          if(index==0) return SizedBox(width: 12);
          else if(index%2 == 1) return curationContainer(((index-1)/2).floor());
          else return SizedBox(width: 22);
        }
      )
    );
  }

  curationContainer(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
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
            children: [

            ]
          )
        )
      )
    );
  }
}

var curationType = ['장르별', '상황별', '무드별'];