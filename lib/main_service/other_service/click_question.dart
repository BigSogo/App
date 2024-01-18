import 'package:flutter/material.dart';

class ClickQ extends StatefulWidget {
  @override
  _ClickQState createState() => _ClickQState();
}

class _ClickQState extends State<ClickQ>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("질문 클릭한 곳입니다."),
    );
  }
}