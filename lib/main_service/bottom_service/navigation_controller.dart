import 'package:bigsogo/main_service/other_service/search_result.dart';
import 'package:flutter/material.dart';

import 'package:bigsogo/main_service/bottom_service/home_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/QnA_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/setting_fragment.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../other_service/notification_activity.dart';

List<String> ProFileData = [];
List<String> QnAData = [];


class BarControl extends StatefulWidget {
  @override
  State<BarControl> createState() => _BarControlState();
}


class _BarControlState extends State<BarControl> {

  //===============//===============//===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============//===============//===============

  Future<SearchResult> fetchData(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.1.8.72:8080/question/search?keyword=$keyword'),
      );

      if (response.statusCode == 200) {
        final SearchResult result = SearchResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));

        // result 객체를 사용하여 필요한 작업 수행
        setState(() {
          QnAData.clear(); // 데이터를 중복해서 추가하지 않도록 리스트를 비워줍니다.
          for (int i = 0; i < result.data.length; i++) {
            QnAData.add(result.data[i].title);
          }
        });

        return result;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }


  //===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============

  bool isSearchVisible = false;
  bool isSearchClicked = false;
  late FocusNode searchFocusNode;
  final _contentEditController = TextEditingController();

  int _selectedIndex = 0;

  //===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchVisible
            ? TextField(
          onEditingComplete: () {
            if (_contentEditController.text.isNotEmpty) {
              searchFocusNode.unfocus(); // 포커스 해제
              setState(() {
                isSearchClicked = true;
                searchKeyword(_contentEditController.text);
              });
            }
            else {
              isSearchClicked = false;
            }

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

                  isSearchClicked = true;
                  searchKeyword(_contentEditController.text);

                } else {
                  isSearchVisible = !isSearchClicked;
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
          isSearchClicked
              ? Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Text(
                  "ProFile",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: ProFileData.length > 0
                    ? ListView.builder(
                  itemCount: ProFileData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print(index);
                      },
                      child: Container(
                        height: 70,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          borderRadius: BorderRadius.circular(8), // Card 테두리 모양
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(ProFileData[index]),
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Text('사용자 검색결과가 없습니다.')),
                ),
              ),

              Container(
                color: Colors.white,
                width: double.infinity,
                child: Text(
                  "QnA",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: QnAData.length > 0
                    ? ListView.builder(
                  itemCount: QnAData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print(index);
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          borderRadius: BorderRadius.circular(8), // Card 테두리 모양
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(QnAData[index]),
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Text('QnA 검색결과가 없습니다.')),
                ),
              ),
            ],
          )
              : SizedBox.shrink(), // isSearchClicked가 false일 때는 공간 차지하지 않도록
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

  //===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============

  void searchKeyword(String searchWord) {
    String keyword = Uri.encodeComponent(searchWord); // 한글 등의 특수문자를 URL 인코딩
    fetchData(keyword);
  }


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
}
