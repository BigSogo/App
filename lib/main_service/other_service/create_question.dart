import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../bottom_service/UserDataModel.dart';
import '../bottom_service/question/QnA_fragment.dart';


class CreateQ extends StatefulWidget {
  @override
  _CreateQState createState() => _CreateQState();
}

class CommentRequest {
  String title;
  String content;


  CommentRequest(this.title, this.content);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}

class _CreateQState extends State<CreateQ> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _isSubmitButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  //========//========//========//========//========//========//========//========//========//========
  //========//========//========//========//========//========//========//========//========//========

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  asyncMethod() async { // 이거 함수임
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 서버에 토큰넣어서 요청 보냄
    if (userInfo != null && userInfo != '') { // null체크 토큰이 없을 때 구별
      print("statusCode : ${userInfo}");
      final response = await http.get(Uri.parse("http://10.1.8.72:8080/user"), headers: {HttpHeaders.authorizationHeader:userInfo});

      var result = BaseUserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      // 서버코드가 200으로 왔을 때 성ㄱ공
      print("statusCode : ${result.data}");
      if (result.code == 200){
        // 여기서 서버에서 받은 데이터로 잘 하시면 됨니다.
        print("userInfo 성공: $userInfo");
      }
      else {
        // 서버 코드가 200이 아닐때 즉 값이 이상할 때
        print("그냥 음 아잇 서버코드가 200이 아님;; ${result.code}");
      }
    }
    else {
      print("asyncMethodUserInfoIsNull : $userInfo");
    }
  }

  //========//========//========//========//========//========//========//========//========//========
  //========//========//========//========//========//========//========//========//========//========

  Future<void> addQuestion(String title, String content) async {
    final String url = 'http://152.67.214.13:8080/question'; // 서버의 Comment API URL로 변경하세요.

    // CommentRequest 객체 생성
    CommentRequest requestBody = CommentRequest(title, content);

    // CommentRequest 객체를 JSON으로 변환
    Map<String, dynamic> jsonMap = requestBody.toJson();

    // 변환된 JSON 출력
    print("create_question's jsonMap : $jsonMap");
    print("userInfo : $userInfo");

    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode(requestBody.toJson()),
        headers: {
          HttpHeaders.authorizationHeader: userInfo,
          HttpHeaders.contentTypeHeader: 'application/json',
          'accept': 'application/json', // 이 부분을 추가
        },
      );

      print("실행확인");

      if (response.statusCode == 200) {
        print('질문이 추가되었습니다.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QnA()
          ),
        );
        // 화면 갱신
        setState(() {});
      } else {
        print('질문 추가 실패. Status code: ${response.statusCode}' + response.body);
      }
    } finally {
      client.close();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('정말로 이 작업을 수행하시겠습니까?'),
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
                addQuestion(_titleController.text, _contentController.text);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: Color(0xFFF5FBFF),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "제목",
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.grey, width: 1),
                        )),
                    child: TextField(
                      controller: _titleController,
                      onChanged: (value) {
                        setState(() {
                          _isSubmitButtonEnabled =
                              value.trim().isNotEmpty &&
                                  _contentController.text.trim().isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                        hintText: '제목을 입력하세요.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 600,
                  color: Color(0xFFF5FBFF),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "내용",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Colors.grey, width: 1),
                                top: BorderSide(color: Colors.grey, width: 1),
                                bottom: BorderSide(color: Colors.grey, width: 1),
                                right: BorderSide(color: Colors.grey, width: 1),
                              )),
                          child: TextField(
                            controller: _contentController,
                            onChanged: (value) {
                              setState(() {
                                _isSubmitButtonEnabled =
                                    _titleController.text.trim().isNotEmpty &&
                                        value.trim().isNotEmpty;
                              });
                            },
                            maxLines: 15,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              hintText: '내용을 입력하세요.',
                            ),
                          )),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: Container(
                    width: 60,
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        if (_isSubmitButtonEnabled) {
                          print("와 Q 등록 완료");

                          _showConfirmationDialog();

                        }
                        else {
                          Fluttertoast.showToast(
                            msg: "빈 곳이 있습니다.",
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 20,
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                        // 버튼 클릭 시 수행할 동작 추가
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF4B66DC)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "제출",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
