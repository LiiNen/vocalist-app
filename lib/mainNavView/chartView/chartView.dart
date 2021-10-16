import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class ChartView extends StatefulWidget {
  @override
  State<ChartView> createState() => _ChartView();
}
class _ChartView extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '인기차트')
    );
  }
}