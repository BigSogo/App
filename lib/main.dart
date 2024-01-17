import 'package:flutter/material.dart';

import 'log_in/first_activity.dart';

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
      theme: ThemeData(fontFamily: "Pretendard"),
      themeMode: ThemeMode.system,
    );
  }
}


