import 'package:flutter/material.dart';
import 'package:vocalist/adMob/adMobBanner.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/collections/style.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/scrapView/userListContainer.dart';
import 'package:vocalist/restApi/searchApi.dart';

class SearchFriendView extends StatefulWidget {
  final dynamic backCallback;
  SearchFriendView({this.backCallback});

  @override
  State<SearchFriendView> createState() => _SearchFriendView();
}
class _SearchFriendView extends State<SearchFriendView> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  var onFilterSelected = 0;
  var filterTitleList = ['', '이름으로 검색', '이메일로 검색'];

  bool isNameLoaded = false;
  var userByName = [];
  bool isEmailLoaded = false;
  var userByEmail = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        appBar: DefaultAppBar(title: '친구 검색', back: true, backCallback: widget.backCallback,),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                searchTextField(),
                searchFilterContainer(),
                lineDivider(context: context),
                isNameLoaded && (onFilterSelected == 0 || onFilterSelected == 1) ?
                  UserListContainer(userList: userByName, searchType: '이름',) : Container(),
                isEmailLoaded && (onFilterSelected == 0 || onFilterSelected == 2) ?
                  UserListContainer(userList: userByEmail, searchType: '이메일',) : Container(),
                isNameLoaded && isEmailLoaded && !isAdIgnore ? AdMobBanner() : Container()
              ]
            )
          )
        )
      )
    );
  }

  searchTextField() {
    return Container(
      margin: EdgeInsets.only(top: 21),
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

  searchFilterContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          searchFilterItem(1),
          SizedBox(width: 11),
          searchFilterItem(2),
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

  searchAction(String input) async {
    setState(() {
      isNameLoaded = false;
      userByName = [];
      isEmailLoaded = false;
      userByEmail = [];
    });
    await _searchName(input);
    await _searchEmail(input);
  }

  _searchName(String input) async {
    var _temp = await searchUserName(userId: userInfo.id, input: input);
    if(_temp != null) {
      setState(() {
        userByName = _temp;
        isNameLoaded = true;
      });
    }
  }

  _searchEmail(String input) async {
    var _temp = await searchUserEmail(userId: userInfo.id, input: input);
    if(_temp != null) {
      setState(() {
        userByEmail = _temp;
        isEmailLoaded = true;
      });
    }
  }
}