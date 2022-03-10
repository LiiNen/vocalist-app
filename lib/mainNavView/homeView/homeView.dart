import 'package:flutter/material.dart';
import 'package:vocalist/adMob/adMobItem.dart';
import 'package:vocalist/collections/statelessWidget.dart';
import 'package:vocalist/mainNavView/homeView/homeCurationContainer.dart';
import 'package:vocalist/mainNavView/homeView/homePlaylistContainer.dart';
import 'package:vocalist/mainNavView/homeView/musicSuggestionContainer.dart';
import 'package:vocalist/restApi/ctypeApi.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}
class _HomeView extends State<HomeView> {

  var ctypeList = [];

  @override
  void initState() {
    super.initState();
    _getCtype();
  }

  _getCtype() async {
    var temp = await getCtype(id: 0);
    if(temp != null) {
      setState(() {
        ctypeList = temp;
      });
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
          children: [
            SizedBox(height: 7),
            MusicSuggestionContainer(),
            HomePlaylistContainer(),
            AdMobBanner(),
            MusicSuggestionContainer(isNew: true),
          ]
          + curationContainerList
        )
      ),
    );
  }
}