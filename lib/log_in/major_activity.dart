import 'dart:convert';
import 'package:bigsogo/main_service/data/search_result.dart';
import 'package:flutter/material.dart';
import 'package:bigsogo/log_in/login_activity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Major extends StatefulWidget {
  final String textFieldController;
  final String confirmPasswordController;
  final String nameController;

  Major({
    required this.textFieldController,
    required this.confirmPasswordController,
    required this.nameController,
  });

  @override
  _MajorState createState() => _MajorState();
}

class _MajorState extends State<Major> {
  List<String> selectedMajors = [];

  Map<String, bool> majors = {
    '웹': false,
    '서버': false,
    '안드로이드': false,
    'iOS': false,
    '임베디드': false,
    'AI': false,
    '보안': false,
    '데이터분석가': false,
    '디자이너': false,
    'PM': false,
    '게임': false,
  };

  void updateSelectedMajors(String major, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedMajors.add(major);
      } else {
        selectedMajors.remove(major);
      }
    });
  }

  Future<void> sendUserDataToServer() async {
    final url = Uri.parse('http://10.1.8.72:8080/user');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.textFieldController.toString(),
          'username': widget.nameController.toString(),
          'password': widget.confirmPasswordController.toString(),
          'major': selectedMajors,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['code'] == 0) {
          print('회원가입 성공: ${responseData['message']}');
          // 성공 시 추가적인 처리를 수행할 수 있습니다.
        } else {
          print('회원가입 실패: ${responseData['message']}');
          // 실패 시 처리를 수행할 수 있습니다.
        }
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> errorData = json.decode(response.body);

        if (errorData.containsKey('detail')) {
          final List<dynamic> errorDetails = errorData['detail'];
          errorDetails.forEach((errorDetail) {
            print('유효성 검사 오류: ${errorDetail['msg']}');
            // 실패 시 메시지 출력 또는 사용자에게 알림을 표시할 수 있습니다.
          });
        } else {
          print('유효성 검사 오류: 서버에서 제공한 형식과 다른 응답입니다.');
        }
      } else {
        print('회원가입 실패: ${response.statusCode}');
        // 실패 시 처리를 수행할 수 있습니다.
      }
    } catch (e) {
      print('오류 발생: $e');
      // 예외 처리를 수행할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:[
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "전공 선택",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "본인에게 맞는 전공을 골라주세요. (복수 선택 가능)",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child:Column(
                children: [
                  for (var entry in majors.entries)
                    CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      onChanged: (bool? value) {
                        setState(() {
                          majors[entry.key] = value!;
                          updateSelectedMajors(entry.key, value);
                        });
                      },
                    ),
                ],
              ),
            ),
            // 체크박스 목록 추가

            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  print("선택된 전공들: $selectedMajors");

                  await sendUserDataToServer();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4B66DC)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                ),
                child: Text("시작하기", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                )),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 450,
                height: 150,
                color: Colors.redAccent,
              ),
            )
          ],
        ),]
      ),
    );
  }
}