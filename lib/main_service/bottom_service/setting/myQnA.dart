import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../data/publickQ_data.dart';
import '../../data/question_1.dart';
import '../../data/search_result.dart';
import '../question/QuestionAnswer.dart';

class MyQnA extends StatefulWidget {
  final int userId;
  // 생성자를 통해 데이터를 받음
  MyQnA({required this.userId});
  @override
  _MyQnA createState() => _MyQnA(userId: userId);
}

class _MyQnA extends State<MyQnA> {

  @override
  void initState() {
    logger.d("message");
    _getMyQnAs();
    super.initState();
  }
  Logger logger = Logger();
  static final storage =
  FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userToken = ''; // storage에 있는 유저 정보를 저장
  final int userId;
  // 생성자를 통해 데이터를 받음
  _MyQnA({required this.userId});
  List<Data> QnALsit = [];


  _getMyQnAs() async {
    userToken = await storage.read(key: 'login');
    if (userToken != null){
      final response = await http.get(
          Uri.parse("http://152.67.214.13:8080/question/my"),
          headers: {HttpHeaders.authorizationHeader: userToken});
      logger.d("inuser");
      if (response.statusCode == 200){
        logger.d("200확인");
        var request = MyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        setState(() {
          QnALsit = request.data;
        });
        logger.d("$QnALsit");
      }
      else{
        logger.e("${response}");
      }
    }
  }
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
          body: ListView.separated(
              itemCount: QnALsit.length,
              itemBuilder:  (BuildContext ctx, int idx) {
                logger.d("test$idx");
                return Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            var dataList = [
                              QnALsit[idx].id.toString(),
                              QnALsit[idx].title,
                              QnALsit[idx].writer.profileImg,
                              QnALsit[idx].writer.username,
                              QnALsit[idx].content,
                              QnALsit[idx].writer.major.toString()
                            ];
                            String majorList = "";
                            for (int j = 0; j < QnALsit[idx].writer.major.length; j++) {
                              majorList += " #" + (QnALsit[idx].writer.major[j]);
                            }
                            dataList.add(majorList);
                            logger.d("message ${dataList}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QAnswer(
                                int.parse(dataList[0])
                              )),
                            );
                          },
                          child: Text("Q.${QnALsit[idx].title}"),
                        ),
                        SizedBox(height: 10,)
                      ],
                    ));
              },separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          ),
        )
    );
  }
}