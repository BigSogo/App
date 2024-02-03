import 'package:bigsogo/main_service/bottom_service/setting/setting_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePotofolio extends StatefulWidget {
  @override
  _CreatePotofolioState createState() => _CreatePotofolioState();
}

class _CreatePotofolioState extends State<CreatePotofolio> {
  final inputNameController = TextEditingController();
  final inputContactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Scaffold(
          appBar: AppBar(
            shape: const Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: inputNameController,
              ),
              TextField(
                controller: inputContactController,
              ),
              ElevatedButton(onPressed: (){}, child: Text("제출"))
            ],
          ),
        )
    );
  }
}