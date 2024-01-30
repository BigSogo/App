import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../other_service/publickQ_data.dart';

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

  Future<List<Data>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.1.8.72:8080/question/list'),
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

            canViewQList.add(row);

            for (int j = 0; j < dataList[i].writer.major.length; j++) {
              majorList += " #" + (dataList[i].writer.major[j]);
            }
          }
          print("canViewList : $canViewQList");

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
      body: ListView.builder(
        itemCount: canViewQList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print(canViewQList[index][0]);
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
                          Text( " Q. "+ canViewQList[index][1], style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),),
                        ],
                      ),

                      Container(
                        height: 70,
                        child: RichText(
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
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          ClipOval(
                            child: Image.network(
                              canViewQList[index][2],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover, // 이미지를 원에 맞게 잘라내기 위해 BoxFit 설정
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 250,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(canViewQList[index][3], style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),),
                                  ],
                                ),
                              ),
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
      ),
    );
  }

}
