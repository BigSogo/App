import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("알림 뷰입니다."),

    );
  }
}