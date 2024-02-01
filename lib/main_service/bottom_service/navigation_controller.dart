import 'package:bigsogo/main_service/bottom_service/question/QuestionAnswer.dart';
import 'package:bigsogo/main_service/data/UserData.dart';
import 'package:bigsogo/main_service/data/search_result.dart';
import 'package:flutter/material.dart';

import 'package:bigsogo/main_service/bottom_service/home_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/question/QnA_fragment.dart';
import 'package:bigsogo/main_service/bottom_service/setting_fragment.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../other_service/notification_activity.dart';

List<String> ProFileData = [];
List<String> QnAData = [];
List<int> QnAdataId = [];
List<List<String>> canUserData = [];
String majorList = "";


class BarControl extends StatefulWidget {
  @override
  State<BarControl> createState() => _BarControlState();

}


class _BarControlState extends State<BarControl> {

  //===============//===============//===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============//===============//===============

  Future<SearchResult> fetchData(String keyword) async {
    print("Future<SearchResult> 작동죔, keyWord: $keyword");
    try {
      final response = await http.get(
        Uri.parse('http://152.67.214.13:8080/question/search?keyword=${keyword}')
      );

      if (response.statusCode == 200) {
        final SearchResult result = SearchResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        print("QnAData : $QnAData"); // QnAData == []

        await Future.delayed(Duration(seconds: 0)); // 비동기 동작 완료를 기다림
        // result 객체를 사용하여 필요한 작업 수행
        QnAData.clear(); // 데이터를 중복해서 추가하지 않도록 리스트를 비워줍니다.
        QnAdataId.clear();
        print("result : ${result.data}");

        setState(() {
          for (int i = 0; i < result.data.length; i++) {
            QnAData.add(result.data[i].title);
            QnAdataId.add(result.data[i].id);
          }
        });

        print("QnAData : $QnAData");
        print("QnADataId : $QnAdataId");



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

  Future<List<UserData>> fetchDataUser(String keyword) async {
    print("Future<List<UserData>> 작동죔, keyWord: $keyword");
    try {
      print("터진곳 확인용 로그");

      final response = await http.get(
        Uri.parse('http://152.67.214.13:8080/user/search?query=$keyword'),
      headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        print("터진곳 확인용 로그1");
        final Map<String, dynamic> decodedData = json.decode(utf8.decode(response.bodyBytes));
        print("터진곳 확인용 로그2");

        await Future.delayed(Duration(seconds: 0)); // 비동기 동작 완료를 기다림
        // result 객체를 사용하여 필요한 작업 수행
        print("터진곳 확인용 로그3");

        final List<dynamic> dataList = decodedData['data'] as List<dynamic>;
        final List<UserData> userList = dataList.map((item) => UserData.fromJson(item)).toList();
        print("터진곳 확인용 로그4");
        canUserData.clear();

        setState(() {
          for (int i = 0; i < userList.length; i++) {
            // 리스트의 길이를 확인하고 필요할 경우 초기화합니다.

            List<String> row = [];
            row.add(userList[i].profileImg);
            row.add(userList[i].username);

            // 각 행을 리스트에 추가합니다.
            canUserData.add(row);

            print("userList 넣은 후, 전체 : ${canUserData[i]}");

            // majorList 초기화
            majorList = "";

            for (int j = 0; j < userList[i].major.length; j++) {
              majorList += " #" + userList[i].major[j];
            }

          }
        });
        print("터진곳 확인용 로그5");
        print("userList : $userList");


        print("canUserData : $canUserData");

        return userList;

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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (isSearchVisible) {
              setState(() {
                searchFocusNode.requestFocus();
                isSearchVisible = false;
                isSearchClicked = false;
                _contentEditController.text = "";

              });
            }
            else {
              Navigator.pop(context);
            }
          },
        ),
        title: isSearchVisible
            ? TextField(
          onEditingComplete: () {
            if (_contentEditController.text.isNotEmpty) {
              setState(() {
                isSearchClicked = true;
                searchKeyword_QnA(_contentEditController.text);
                searchKeyword_profile(_contentEditController.text);
              });
            }
            else {
              setState(() {
                isSearchClicked = false;
              });
            }

            if (isSearchVisible) {
              searchFocusNode.requestFocus();
            }

          },
          controller: _contentEditController,
          focusNode: searchFocusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "검색어를 입력하세요",
            border: InputBorder.none,
          ),
        ) : Text(""),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_contentEditController.text.isNotEmpty) {

                  isSearchClicked = true;
                  searchKeyword_QnA(_contentEditController.text);
                  searchKeyword_profile(_contentEditController.text);


                } else {
                  setState(() {
                    isSearchVisible = !isSearchVisible;
                    isSearchClicked = false;
                  });
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
          Stack(
          children: [
            SafeArea(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            isSearchClicked ? Positioned.fill(
                child: Column(
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
                      child: Container(
                        color: Colors.white,
                        child: canUserData.length > 0
                            ? ListView.builder(
                          itemCount: canUserData.length,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Image.network(
                                        canUserData[index][0],
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover, // 이미지를 원에 맞게 잘라내기 위해 BoxFit 설정
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(canUserData[index][1]),
                                        Container(
                                          height: 20,
                                          child: RichText(
                                            text: TextSpan(
                                              text: majorList,
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),

                                      ],
                                    )
                                    
                                  ]
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
                            child: Center(child: Text('사용자 검색 결과가 없습니다.')),
                          ),
                        ),
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
                        child: Container(
                          color: Colors.white,
                          child: QnAData.length > 0
                              ? ListView.builder(
                            itemCount: QnAData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print(index);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QAnswer(
                                        canViewQList[QnAdataId[index]-1],
                                      ),
                                    ),
                                  );
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
                                    child: Text(" Q. " + QnAData[index], style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15
                                    ),),
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
                              child: Center(child: Text('QnA 검색결과가 없습니다.')),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ],
      ),




      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
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

  void searchKeyword_QnA(String searchWord) {
    String keyword = Uri.encodeComponent(searchWord); // 한글 등의 특수문자를 URL 인코딩
    fetchData(keyword);
  }
  void searchKeyword_profile(String searchWord) {
    String keyword = Uri.encodeComponent(searchWord); // 한글 등의 특수문자를 URL 인코딩
    fetchDataUser(keyword);
  }


  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    QnA(),
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
