import 'dart:io';

import 'package:bigsogo/main_service/bottom_service/question/QnA_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/question_1.dart';
import '../UserDataModel.dart';

var iconColor = Color(0xFFA8A8A8);
String thisUserName = "";
List<List<String>> commentList = [];

//=============//=============//=============//=============//=============

class QAnswer extends StatefulWidget {
  final List<String> clickQList; // 클릭한 질문의 데이터를 받을 변수 추가

  QAnswer(this.clickQList); // 생성자 수정


  @override
  _QAnswerState createState() => _QAnswerState();
}

class CommentRequest {
  String content;
  int questionId;

  CommentRequest(this.content, this.questionId);

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'question_id': questionId,
    };
  }
}

//=============//=============//=============//=============//=============

class _QAnswerState extends State<QAnswer>{
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    takeComment(int.parse(widget.clickQList[0]));
    asyncMethod();
  }

  Future<void> addComment(String content, int qId) async {
    final String url = 'http://152.67.214.13:8080/comment'; // 서버의 Comment API URL로 변경하세요.


    CommentRequest requestBody = CommentRequest(content, qId);

    print("content : $content , question_id : $qId , userInfo : $userInfo");

    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode(requestBody.toJson()),
        headers: {
          HttpHeaders.authorizationHeader: userInfo,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      print("실행확인");

      if (response.statusCode == 200) {
        print('댓글이 추가되었습니다.');
        await takeComment(int.parse(widget.clickQList[0]));
        // 화면 갱신
        setState(() {});
      } else {
        print('댓글 추가 실패. Status code: ${response.statusCode}' + response.body);
      }
    } finally {
      client.close();
    }
  }

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
        } else {
          print("서버 코드가 200이 아님;; ${result.code}");
        }
      } catch (e) {
        print("Error during http.get: $e");
      }
    }


  }

  //===============//===============//===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============//===============//===============

  Future<void> takeComment(int quesId) async {
    print("Future<Question1> 작동죔, keyWord: $quesId");
    print(widget.clickQList[5]);
    try {
      final response = await http.get(
          Uri.parse('http://152.67.214.13:8080/question/?id=${quesId.toString()}')
      );

      print("QuestionAnswer 작동 확인");

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        print("Decoded Data: $decodedData");

        final Question1 result = Question1.fromJson(decodedData);

        print("QuestionAnswer 작동 확인2");

        await Future.delayed(Duration(seconds: 0)); // 비동기 동작 완료를 기다림
        // result 객체를 사용하여 필요한 작업 수행

        setState(() {
          commentList.clear();

          for (int i = 0; i < result.data.comments.length; i++) {
            List<String> row = [];

            row.add("${result.data.comments[i]?.id}");
            row.add("${result.data.comments[i]?.writer.profileImg}");
            row.add("${result.data.comments[i]?.writer.username}");
            row.add("#${result.data.comments[i]?.writer.major.join(' #')}");
            row.add("${result.data.comments[i]?.content}");


            print("row : $row");
            commentList.add(row);
          }


        });

        return null;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  //===============//===============//===============//===============//===============//===============//===============//===============
  //===============//===============//===============//===============//===============//===============//===============//===============


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
                addComment(commentController.text, int.parse(widget.clickQList[0]));
                commentController.clear(); // 댓글 추가 후 텍스트 필드 내용 초기화

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


  void _showMoreOptions(BuildContext context, int cmtId) {
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
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제하기'),
                onTap: () {
                  // 삭제하기 로직을 추가하세요.
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
                              " Q. " + widget.clickQList[1],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                  widget.clickQList[4],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    color: Color(0xFF343434),
                                  ),
                                maxLines: 20,
                                overflow: TextOverflow.ellipsis,
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
                              widget.clickQList[2],
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
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.clickQList[3],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                height: 30,
                                width: 300,
                                child: Expanded(
                                  child: Text(
                                      widget.clickQList[5],
                                      style: TextStyle(
                                        fontSize: 13,
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


             // 이 부분에 ListView.builder를 사용해서 commentList값 넣기
            commentList.length > 0 ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                child: ListView.builder(
                    itemCount: commentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF15273E),
                                    width: 1
                                )
                            ),
                          ),
        
                          child:
                          Column(
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      commentList[index][1],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // 수직 방향으로 시작점에 맞추도록 설정
        
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              commentList[index][2],
                                              maxLines: 1, // 최대 표시할 줄 수
                                              overflow: TextOverflow.ellipsis, // 넘칠 경우 "..."으로 표시
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),

                                            commentList[index][2] == thisUserName
                                             ? Padding(
                                              padding: const EdgeInsets.only(left: 100),
                                              child: IconButton(onPressed: (){
                                                _showMoreOptions(context, int.parse(commentList[index][0]));

                                              }, icon: Icon(Icons.more_vert)),
                                            ) : Text("")
                                          ],
                                        ),

                                        Text(commentList[index][3],
                                          style: TextStyle(
                                              fontSize: 12
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width : 350,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("A. " + commentList[index][4],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  ),),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ) : Container(height: 410, child: Center(child: Text("작성된 답글이 없습니다."))),

            //=======//=======//=======//=======//=======//=======//=======//=======//=======//=======
            Row(
              children: [
                Expanded(
                  flex: 6, // 첫 번째 Container가 차지하는 비율
                  child: Container(
                    color: Color(0xFFF5FBFF),
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {

                          setState(() {
                            iconColor = value.trim().isNotEmpty ? Color(0xFF4C66DC) : Color(0xFFA8A8A8);
                          });

                        },
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: "댓글을 입력하세요.",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1, // 두 번째 Container가 차지하는 비율
                  child: Container(

                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color : Color(0xFFA0B2EE),
                              width: 1
                          )
                      ),
                      color: Color(0xFFF5FBFF),
                    ),

                    height: 60,
                    child: IconButton(
                      onPressed: () {
                        // 검색 버튼을 눌렀을 때의 동작

                        if (commentController.text.isNotEmpty) {
                          print(widget.clickQList[0]);
                          _showConfirmationDialog();
                        }
                      },
                      icon: Icon(Icons.comment, color: iconColor,),
                    ),
                  ),
                )
              ],
            ),
            //=======//=======//=======//=======//=======//=======//=======//=======//=======//=======

          ],
        ),
      ),

    );
  }
}