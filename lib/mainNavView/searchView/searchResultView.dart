import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/adMob/adMobBanner.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/searchView/searchView.dart';
import 'package:vocalist/music/curationListContainer.dart';
import 'package:vocalist/music/musicListContainer.dart';
import 'package:vocalist/restApi/searchApi.dart';

import '../../main.dart';

class SearchResultView extends StatefulWidget {
  final String input;
  final int index;
  final dynamic backCallback;
  SearchResultView({required this.input, required this.index, this.backCallback});

  @override
  State<SearchResultView> createState() => _SearchResultView(input, index);
}
class _SearchResultView extends State<SearchResultView> {
  String input;
  int index;
  _SearchResultView(this.input, this.index);

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  var musicList = [];
  bool isLoaded = false;

  var onFilterSelected = 0;
  var filterTitleList = ['전체', '곡 제목', '가수', '큐레이션'];

  @override
  void initState() {
    super.initState();
    onFilterSelected = index;
    controller.text = input;
    _getResult();
  }

  _getResult() async {
    var _temp = await searchTitle(userId: userInfo.id, input: input);
    musicList.add(_temp);
    _temp = await searchArtist(userId: userInfo.id, input: input);
    musicList.add(_temp);
    _temp = await searchCuration(userId: userInfo.id, input: input);
    musicList.add(_temp);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(title: '검색 결과', back: true, search: false, backCallback: widget.backCallback,),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                searchTextField(),
                searchFilterContainer(),
                lineDivider(context: context, margin: 16),
                /// title search
                isLoaded && onFilterSelected != 0 && musicList[onFilterSelected-1] != null && onFilterSelected == 1?
                  MusicListContainer(musicList: musicList[0].take(20).toList(), highlight: input, index: 1) :
                  Container(),
                /// artist search
                isLoaded && onFilterSelected != 0 && musicList[onFilterSelected-1] != null && onFilterSelected == 2 ?
                  MusicListContainer(musicList: musicList[1].take(20).toList(), highlight: input, index: 2) :
                  Container(),
                /// curation search
                isLoaded && onFilterSelected != 0 && musicList[onFilterSelected-1] != null && onFilterSelected == 3 ?
                  CurationListContainer(curationList: musicList[2].take(6).toList(),) :
                  Container(),
                /// for total search
                isLoaded && onFilterSelected == 0 && musicList[0] != null ?
                  MusicListContainer(musicList: musicList[0].take(5).toList(), highlight: input, index: 1) :
                  Container(),
                isLoaded && onFilterSelected == 0 && musicList[1] != null ?
                  MusicListContainer(musicList: musicList[1].take(5).toList(), highlight: input, index: 2) :
                  Container(),
                isLoaded && onFilterSelected == 0 && musicList[2] != null ?
                CurationListContainer(curationList: musicList[2].take(6).toList(),) :
                  Container(),
                isLoaded && onFilterSelected == 0 ? Column(
                  children: [
                    SizedBox(height: 34),
                    AdMobBanner(),
                  ]
                ) : Container()
              ]
            )
          )
        )
      )
    );
  }

  searchTextField() {
    return Container(
      margin: EdgeInsets.only(top: 21, left: 16, right: 16),
      height: 38,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          color: Color(0xffcecece),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xffcecece)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xffcecece)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
              borderSide: BorderSide(color: Color(0xffcecece)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            hintText: '검색어를 입력하세요',
            hintStyle: textStyle(color: Color(0xff8a8a8a), weight: 400, size: 12.0),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 13, right: 18),
              child: Icon(Icons.search, size: 14, color: Color(0xff7c7c7c)),
            ),
            prefixIconConstraints: BoxConstraints(maxWidth: 45, maxHeight: 40),
            suffixIcon: controller.text != '' ? Padding(
              padding: EdgeInsets.only(left: 10, right: 15),
              child: IconButton(
                onPressed: () => {setState(() {textFieldClear(controller);})},
                icon: Icon(Icons.cancel, size: 14, color: Color(0xff7c7c7c))
              )
            ) : null,
            suffixIconConstraints: BoxConstraints(maxWidth: 45, maxHeight: 40),
          ),
          style: textStyle(color: Color(0xff463f56), weight: 600, size: 12.0),
          onChanged: (value) => {setState(() {})},
          onSubmitted: (value) => {setState(() {searchAction(value);})},
        )
      )
    );
  }

  searchAction(String input) async {
    if(input != '') {
      final pref = await SharedPreferences.getInstance();
      searchHistoryList.remove(input);
      searchHistoryList.insert(0, input);
      pref.setStringList('searchHistory', searchHistoryList);

      navigatorPush(context: context, widget: SearchResultView(input: input, index: onFilterSelected, backCallback: widget.backCallback,), replacement: true);
    }
  }

  searchFilterContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
      child: Row(
        children: [
          searchFilterItem(1),
          SizedBox(width: 11),
          searchFilterItem(2),
          SizedBox(width: 11),
          searchFilterItem(3)
        ]
      )
    );
  }

  searchFilterItem(int index) {
    bool _selected = onFilterSelected == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            if(_selected) onFilterSelected = 0;
            else onFilterSelected = index;
          });
        },
        child: Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.all(color: Color(0xffe5e5e5), width: 1),
            color: _selected ? Color(0xff5642a0) : Color(0x005642a0),
          ),
          child: Center(child: Text(filterTitleList[index], style: textStyle(color: _selected ? Colors.white : Color(0xff7b7b7b), weight: 500, size: 12.0)))
        )
      )
    );
  }
}