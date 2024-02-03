import 'dart:io';

import 'package:bigsogo/log_in/login_activity.dart';
import 'package:bigsogo/main_service/bottom_service/question/QuestionAnswer.dart';
import 'package:bigsogo/main_service/other_service/create_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bigsogo/main_service/data/publickQ_data.dart';

import '../../data/UserDataModel.dart';

List<List<String>> canViewQList = [];
String majorList = "";
String thisUserName = "히히 테스트용으로 막만든 유저 이름이지";

class QnA extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 fetchData 호출
    asyncMethod();
  }

  var isQnaHaving = true;
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _contentTextEditingController = TextEditingController();



  Future<List<Data>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://152.67.214.13:8080/question/list'),
      );
      if (response.statusCode == 200) {
        final MyModel myModel =
        MyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

        print("thisUsername : $thisUserName");

        List<Data> dataList = myModel.data;
        setState(() {
          canViewQList.clear(); // 기존 데이터를 지우고 다시 초기화
          majorList = ""; // 기존 데이터를 지우고 다시 초기화

          for (int i = 0; i < dataList.length; i++) {
            majorList = ""; // 기존 데이터를 지우고 다시 초기화
            List<String> row = [];
            row.add(dataList[i].id.toString());
            row.add(dataList[i].title);
            row.add(dataList[i].writer.profileImg);
            row.add(dataList[i].writer.username);
            row.add(dataList[i].content);


            for (int j = 0; j < dataList[i].writer.major.length; j++) {
              majorList += " #" + (dataList[i].writer.major[j]);
            }

            row.add(majorList);


            canViewQList.add(row);
          }
          print("canViewList : $canViewQList");

          if (canViewQList.isEmpty) {
            isQnaHaving = false;
          }
        });

        return dataList;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  //=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====
  //=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  asyncMethod() async { // 이거 함수임
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');
    print("userInfo : ${userInfo}");

    // user의 정보가 있다면 서버에 토큰넣어서 요청 보냄
    if (userInfo != null) {
      print("userInfo: $userInfo");

      try {
        final response = await http.get(
          Uri.parse("http://152.67.214.13:8080/user"),
          headers: {HttpHeaders.authorizationHeader: userInfo},
        );

        print("Server Response: ${response.statusCode}");
        print("Server Body: ${response.body}");

        var result = BaseUserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));


        print("statusCode2 : ${result.data}");
        print("thisUserName : $thisUserName");

        if (result.code == 200) {
          thisUserName = result.data.username;
          setState(() {

          });
        } else {
          print("서버 코드가 200이 아님;; ${result.code}");
        }
      } catch (e) {
        print("Error during http.get: $e");
      }
    }
  }

  //=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====
  //=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====

  Future<void> deleteQuestion(int questId) async {
    final String url = 'http://152.67.214.13:8080/question/$questId'; // 서버의 Comment API URL로 변경하세요.

    print("deleteQuestion 실행 확인");

    final client = http.Client();
    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: userInfo,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      print("response 요청 확인");

      if (response.statusCode == 200) {
        print('질문이 삭제되었습니다.');
        await fetchData();
        // 화면 갱신
        setState(() {});
      } else {
        print('질문 삭제 실패. Status code: ${response.statusCode}' + response.body);
      }
    } finally {
      client.close();
    }
  }

  void _showDeleteCheckDialog(int questId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('정말로 질문을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 동작 수행
                deleteQuestion(questId);
                // 팝업 닫기
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  //====//====//====//====//====//====//====//====//====//====//====//====//====//====//====


  Future<void> updateQuestion(int questId, String updateTitle, String updatedContent) async {
    final String url = 'http://152.67.214.13:8080/question/$questId'; // 실제 서버 URL로 변경하세요.

    // 준비된 데이터
    Map<String, dynamic> data = {
      'title' : updateTitle,
      'content': updatedContent,
    };

    // 데이터를 JSON 형태로 변환
    String jsonData = jsonEncode(data);

    try {
      final response = await http.put(
          Uri.parse(url),
          body: jsonData,
          headers: {
            'accept': 'application/json', // 이 부분을 추가
            HttpHeaders.authorizationHeader: userInfo,
            HttpHeaders.contentTypeHeader: 'application/json',
          }
      );

      if (response.statusCode == 200) {
        print('질문이 성공적으로 업데이트되었습니다.');

        await fetchData();
        // 화면 갱신
        setState(() {});

      } else {
        print('질문 업데이트 실패. Status code: ${response.statusCode}' + response.body);
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  Future<void> showEditablePopup(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('질문 수정'),
           content: Column(
            children: [
              TextField(
                controller: _titleEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null, // 무제한으로 설정하여 자동으로 높이 조절
                textAlignVertical: TextAlignVertical.top, // 텍스트 필드의 텍스트를 위로 정렬
                textAlign: TextAlign.start, // 왼쪽 정렬 설정
                decoration: InputDecoration(
                  hintText: '제목을 수정해주세요.',
                  labelText: '제목',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextField(
                controller: _contentTextEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null, // 무제한으로 설정하여 자동으로 높이 조절
                textAlignVertical: TextAlignVertical.top, // 텍스트 필드의 텍스트를 위로 정렬
                textAlign: TextAlign.start, // 왼쪽 정렬 설정
                decoration: InputDecoration(
                  hintText: '내용을 수정해주세요.',
                  labelText: '내용',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기 버튼
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String titleText = _titleEditingController.text;
                String contentText = _contentTextEditingController.text;
                // 수정된 내용 사용
                print('Edited Title: $titleText');
                print('Edited Content: $contentText');
                Navigator.of(context).pop(); // 닫기 버튼

                updateQuestion(int.parse(canViewQList[index][0]), titleText, contentText);
              },
              child: Text('저장하기'),
            ),
          ],
        );
      },
    );
  }



  Future<void> editPopupSetting(String title, String content, int index) async {
    _titleEditingController.text = title;
    _contentTextEditingController.text = content; // 추가 텍스트 필드 초기화

    showEditablePopup(context, index);
  }


//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====
//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====

  void _showMoreOptions(BuildContext context, int questId, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // 더보기 창의 UI 구성을 넣으세요.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('수정하기'),
                onTap: () {
                  // 수정하기 로직을 추가하세요.
                  Navigator.pop(context);

                  editPopupSetting(canViewQList[index][1], canViewQList[index][4], index);

                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제하기'),
                onTap: () {
                  // 삭제하기 로직을 추가하세요.
                  Navigator.pop(context);

                  _showDeleteCheckDialog(int.parse(canViewQList[index][0]));

                },
              ),
            ],
          ),
        );
      },
    );
  }

//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====//=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isQnaHaving
          ? ListView.builder(
        itemCount: canViewQList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print(canViewQList[index][0]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QAnswer(
                    canViewQList[index],
                  ),
                ),
              );
            },
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              " Q. " + canViewQList[index][1],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                  canViewQList[index][4],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Color(0xFF343434),
                                  ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Image.network(
                              canViewQList[index][2],
                              // "https://static-cdn.jtvnw.net/jtv_user_pictures/ecd6ee59-9f18-4eec-b8f3-63cd2a9127a5-profile_image-300x300.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 270,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          canViewQList[index][3],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        canViewQList[index][3] == thisUserName
                                        ? Padding(
                                          padding: const EdgeInsets.only(left: 100),
                                          child: IconButton(onPressed: (){
                                            _showMoreOptions(context, int.parse(canViewQList[index][0]), index);

                                          }, icon: Icon(Icons.more_vert)),
                                        ) : Text("")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                height: 20,
                                width: 300,
                                child: Expanded(
                                  child: Text(
                                    canViewQList[index][5],
                                    style: TextStyle(
                                      fontSize: 15, // 더 큰 폰트 크기로 변경해보세요.
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text("QnA가 없습니다."),
      ),
      floatingActionButton: Container(
        width: 65, // 원하는 가로 크기 설정
        height: 65, // 원하는 세로 크기 설정
        child: FloatingActionButton(
          backgroundColor: Color(0xFF4C66DC),
          onPressed: () {
            // 버튼을 눌렀을 때 수행할 동작
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateQ()),
            );
          },
          child: Icon(Icons.edit, color: Colors.white),
          heroTag: 'uniqueHeroTag', // 고유한 태그 지정
          elevation: 6, // 그림자 크기 조절
          mini: false, // 큰 크기로 설정
          shape: RoundedRectangleBorder( // 버튼 모양 설정
            borderRadius: BorderRadius.circular(100), // 반지름을 크기의 절반으로 설정하여 동그랗게 보이도록 함
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
