import 'package:flutter/material.dart';
import 'package:vocalist/adMob/adMobItem.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class EasterEggView extends StatefulWidget {
  @override
  State<EasterEggView> createState() => _EasterEggView();
}
class _EasterEggView extends State<EasterEggView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: '이스터에그를 발견하셨습니다!'),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(10, (index) {
            return Column(
              children: [
                SizedBox(height: 20),
                AdMobBanner()
              ]
            );
          })
        )
      )
    );
  }
}