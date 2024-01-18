import 'package:flutter/material.dart';

import 'log_in/first_activity.dart';

import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BigSogo",
      home: StartActivity(),
      theme: ThemeData(fontFamily: "Pretendard",
      primaryColor: Color(0xFF4B66DC)),
      themeMode: ThemeMode.system,
    );
  }
}


