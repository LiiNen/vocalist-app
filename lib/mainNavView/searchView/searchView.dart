import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/mainNavView/searchView/searchResultView.dart';

class SearchView extends StatefulWidget {
  @override
  State<SearchView> createState() => _SearchView();
}
class _SearchView extends State<SearchView> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  List<String> searchHistoryList = [];
  String _type = '노래';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      searchHistoryList = pref.getStringList('searchHistory') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        appBar: MainAppBar(title: '검색'),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 21),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                searchTextField(),
                searchFilterContainer(),
                recentSearchContainer(),
              ]
            )
          )
        )
      )
    );
  }

  searchTextField() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      child: Container(
        height: 40,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        //   color: Color(0xfff5f5f5)
        // ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            fillColor: Color(0xfff5f5f5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xfff5f5f5)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14),
            hintText: '검색어를 입력하세요',
            hintStyle: textStyle(color: Color(0xff8a8a8a), weight: 400, size: 12.0),
            suffixIcon: controller.text != '' ? IconButton(
              onPressed: () => {setState(() {textFieldClear(controller);})},
              icon: Icon(Icons.cancel, size: 20, color: Colors.grey)
            ) : null
          ),
          style: textStyle(weight: 600, size: 12.0),
          onChanged: (value) => {setState(() {})},
          onSubmitted: (value) => {setState(() {searchAction(value);})},
        )
      )
    );
  }

  searchFilterContainer() {
    return Container(

    );
  }

  recentSearchContainer() {
    return searchHistoryList.length == 0 ? Container() : Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('최근 검색어', style: textStyle(weight: 700, size: 16.0),),
              GestureDetector(
                onTap: () => {setState(() {removeRecent(all: true);})},
                child: Text('전체삭제', style: textStyle(color: Color(0xff8a8a8a), weight: 400, size: 12.0))
              )
            ]
          ),
          SizedBox(height: 20),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8, runSpacing: 8,
            children: searchHistoryList.map((e) => _recentItem(word: e)).toList(),
          )
        ]
      )
    );
  }

  searchAction(String input) async {
    if(input != '') {
      final pref = await SharedPreferences.getInstance();
      searchHistoryList.remove(input);
      searchHistoryList.insert(0, input);
      pref.setStringList('searchHistory', searchHistoryList);

      navigatorPush(context: context, widget: SearchResultView(input: input, type: _type));
    }
  }

  removeRecent({String target='', bool all=false}) async {
    final pref = await SharedPreferences.getInstance();
    if(all) {
      searchHistoryList = [];
      pref.setStringList('searchHistory', []);
    }
    else {
      searchHistoryList.remove(target);
      pref.setStringList('searchHistory', searchHistoryList);
    }
  }

  GestureDetector _recentItem({required String word}) {
    return GestureDetector(
      onTap: () => {setState(() {searchAction(word);})},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Color(0xffd3d7df), width: 1),
          color: Colors.white
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(word,
                style: textStyle(weight: 600, size: 14.0),
                overflow: TextOverflow.ellipsis,
              )),
              SizedBox(width: 4,),
              GestureDetector(
                onTap: () => {setState(() {removeRecent(target: word);})},
                child: Icon(Icons.clear, size: 16,)
              ),
            ],
          )
        )
      )
    );
  }
}