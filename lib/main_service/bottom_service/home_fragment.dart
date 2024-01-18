import 'package:bigsogo/main_service/other_service/search_result.dart';
import 'package:flutter/material.dart';

import 'package:bigsogo/main_service/other_service/notification_activity.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // 원하는 동작 수행
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Text("홈 뷰 입니다."),
        ),
      ),
    );
  }
}
