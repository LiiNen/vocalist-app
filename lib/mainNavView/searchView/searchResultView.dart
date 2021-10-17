import 'package:flutter/material.dart';
import 'package:vocalist/collections/statelessWidget.dart';

class SearchResultView extends StatefulWidget {
  final String input;
  final String type;
  SearchResultView({required this.input, required this.type});

  @override
  State<SearchResultView> createState() => _SearchResultView(input, type);
}
class _SearchResultView extends State<SearchResultView> {
  String input;
  String type;
  _SearchResultView(this.input, this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: '검색 결과', back: true),
    );
  }
}