import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class ScrapView extends StatefulWidget {
  @override
  State<ScrapView> createState() => _ScrapView();
}
class _ScrapView extends State<ScrapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '보관함')
    );
  }
}