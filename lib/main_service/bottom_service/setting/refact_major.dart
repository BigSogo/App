
import 'package:bigsogo/main_service/bottom_service/setting/setting_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Refact_major extends StatefulWidget {

  final List<String> nowMajor;
  // 생성자를 통해 데이터를 받음
  Refact_major({required this.nowMajor});

  @override
  _refact_major createState() => _refact_major(nowMajor:nowMajor);
}

class _refact_major extends State<Refact_major>{
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
  List<String> selectedMajors = [];

  @override
  void initState() {
    for (var entry in nowMajor){
      majors[entry] = true;
    }
    super.initState();
  }
  void updateSelectedMajors(String major, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedMajors.add(major);
      } else {
        selectedMajors.remove(major);
      }
    });
  }

  final List<String> nowMajor;
  // 생성자를 통해 데이터를 받음
  _refact_major({required this.nowMajor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
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

            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {


                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
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
          ],
        ),
      ),
    );
  }
}