import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("검색 결과 곳입니다."),
    );
  }
}