import 'package:flutter/material.dart';

import 'package:bigsogo/main_service/bottom_service/home_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/QnA_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/setting_fragment.dart';

import '../other_service/notification_activity.dart';
import '../other_service/search_result.dart';


class BarControl extends StatefulWidget {
  @override
  State<BarControl> createState() => _BarControlState();
}

class _BarControlState extends State<BarControl> {
  bool isSearchVisible = false;
  bool isSearchClicked = false;
  late FocusNode searchFocusNode;
  final _contentEditController = TextEditingController();

  int _selectedIndex = 0;

  static const data = [
    "ChesPress",
    "Squat",
    "DeadLift",
    "PullUp",
    "OverHeadPress",
  ];

  final List<Widget> _widgetOptions = <Widget>[
    QnA(),
    Home(),
    Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode(); // FocusNode 초기화
  }

  @override
  void dispose() {
    searchFocusNode.dispose(); // dispose에서 FocusNode 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchVisible
            ? TextField(
          onEditingComplete: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchResult()),
            );
          },
          controller: _contentEditController,
          focusNode: searchFocusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "검색어를 입력하세요",
            border: InputBorder.none,
          ),
        )
            : Text(""),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_contentEditController.text.isNotEmpty) {
                  searchFocusNode.unfocus(); // 포커스 해제
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SearchResult()),
                  // );

                  isSearchClicked = !isSearchClicked;

                } else {
                  isSearchVisible = !isSearchVisible;
                }

                if (isSearchVisible) {
                  searchFocusNode.requestFocus();
                }
              });
            },
            child: Icon(Icons.search, size: 30),
          ),
          Padding(padding: EdgeInsets.all(10)),
          GestureDetector(
            onTap: () {
              searchFocusNode.unfocus(); // 포커스 해제
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationView()),
              );
            },
            child: Icon(Icons.notifications_outlined, size: 30),
          ),
          Padding(padding: EdgeInsets.all(10)),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          isSearchClicked ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context , int index) {
              return GestureDetector(
                onTap: () {
                  print(index);
                },
                child: Card(
                  color: Colors.blue, // 배경색
                  margin: EdgeInsets.zero,
                  elevation: 8, // 그림자 높이
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0), // Card 테두리 모양
                  ),
                  child: Text(data[index]),
                ),
              );
            },
          ): Text("")
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF4C66DC),
        onTap: _onItemTapped,
      ),
    );
  }
}
