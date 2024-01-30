import 'package:bigsogo/main_service/bottom_service/question/QuestionAnswer.dart';
import 'package:bigsogo/main_service/other_service/create_question.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../other_service/publickQ_data.dart';

List<List<String>> canViewQList = [];
String majorList = "";

class QnA extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 fetchData 호출
  }

  var isQnaHaving = true;

  Future<List<Data>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://152.67.214.13:8080/question/list'),
      );
      if (response.statusCode == 200) {
        final MyModel myModel =
        MyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));

        List<Data> dataList = myModel.data;
        setState(() {
          canViewQList.clear(); // 기존 데이터를 지우고 다시 초기화
          majorList = ""; // 기존 데이터를 지우고 다시 초기화

          for (int i = 0; i < dataList.length; i++) {
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
              height: 200,
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
                          Text(
                            " Q. " + canViewQList[index][1],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: canViewQList[index][4],
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Color(0xFF343434),
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 270,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      canViewQList[index][3],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                height: 20,
                                width: 300,
                                child: RichText(
                                  text: TextSpan(
                                    text: canViewQList[index][5],
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 버튼을 눌렀을 때 수행할 동작
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateQ()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
