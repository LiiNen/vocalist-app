import 'package:flutter/material.dart';
import 'package:vocalist/adMob/adMobBanner.dart';
import 'package:vocalist/collections/function.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/main.dart';
import 'package:vocalist/mainNavView/homeView/homeCurationContainer.dart';
import 'package:vocalist/mainNavView/homeView/homePlaylistContainer.dart';
import 'package:vocalist/mainNavView/homeView/musicSuggestionContainer.dart';
import 'package:vocalist/mainNavView/settingView/eventView.dart';
import 'package:vocalist/restApi/ctypeApi.dart';
import 'package:vocalist/restApi/eventApi.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}
class _HomeView extends State<HomeView> {

  var ctypeList = [];
  var _eventInfo;
  var _eventBannerImgUrl = '';

  @override
  void initState() {
    super.initState();
    _getCtype();
    _getEvent();
  }

  _getCtype() async {
    var temp = await getCtype(id: 0);
    if(temp != null) {
      setState(() {
        ctypeList = temp;
      });
    }
  }

  _getEvent() async {
    var _temp = await getEvent();
    if(_temp != null) {
      if(_temp['img_banner_url'] != null) {
        setState(() {
          _eventInfo = _temp;
          _eventBannerImgUrl = _eventInfo['img_banner_url'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var curationContainerList = List.generate(ctypeList.length, (index) {
      return HomeCurationContainer(ctypeList[index]);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: '홈'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 7),
            _eventBannerImgUrl != '' ? eventBanner() : Container(),
            MusicSuggestionContainer(isNew: true),
            HomePlaylistContainer(),
            !isAdIgnore ? AdMobBanner() : Container(),
            MusicSuggestionContainer(),
          ]
          + curationContainerList
        )
      ),
    );
  }

  eventBanner() {
    return GestureDetector(
      onTap: () {
        navigatorPush(context: context, widget: EventView(eventInfo: _eventInfo,));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(_eventBannerImgUrl, fit: BoxFit.fitWidth)
      )
    );
  }
}