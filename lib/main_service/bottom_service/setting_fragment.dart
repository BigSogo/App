import 'dart:convert';
import 'dart:io';
import 'package:bigsogo/BaseData.dart';
import 'package:bigsogo/main_service/bottom_service/UserDataModel.dart';
import 'package:bigsogo/main_service/bottom_service/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../log_in/login_activity.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Logger logger = Logger();
  static final storage =
      FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장
  late final Future<UserProfile> myInfo;
  List testContentsName = ["타임벅스", "해커톤", "시몬"];
  List testContentsInfo = [
    "대충 타임벅스 내용입니다. 뭐 안드로이드 맡았어요. 잘 부탁드립니다.",
    "이거 내용이 없었네;;",
    "기억해둬라. 이 드릴은 우주에 바람구멍을 내고, 그 구멍은 뒤따라 오는 이들의 길이 되지. 쓰러져 간 이들의 소망과, 뒤따라 올 이들의 희망! 두 마음을 이중나선에 수놓고서, 내일로 향하는 길을 뚫는다! 그것이 천원돌파. 그것이 그렌라간! 나의 드릴은 하늘을 만들어 낼 드릴이다!!!"
  ];
  String name = "이성은";
  String info = "안녕하세요 안드로이드 개발을 잘 하는 부산 이성은입니다.";

  Future<BaseData<UserProfile>> getMyProfile(int userId) async {
    logger.d("message");
    final response =
        await http.get(Uri.parse("http://10.1.8.72:8080/profile/{$userId}"));
    var result = BaseData<UserProfile>.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
    if (response.statusCode == 200) {
      logger.d(result.data);
      return result;
    } else {
      logger.d(result);
      throw Exception('Failed to load album');
    }
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      logger.d("statusCode : ${userInfo}");
      final response = await http.get(
          Uri.parse("http://152.67.214.13:8080/user"),
          headers: {HttpHeaders.authorizationHeader: userInfo});

      var result =
          BaseUserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      logger.d("statusCode : ${result.data}");
      if (result.code == 200) {
        getMyProfile(result.data);
      }
    } else {
      logger.e('세션이 만료되었습니다.');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // myInfo =  getMyProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
            itemCount: testContentsInfo.length + 1,
            itemBuilder: (BuildContext ctx, int idx) {
              if (idx == 0) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          color: Color(0xFFF5FBFF),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(26, 26, 26, 26),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      'https://static.wikia.nocookie.net/p__/images/8/8a/Shiro_.png/revision/latest?cb=20210703182454&path-prefix=protagonist',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: "Pretendard",
                                                fontWeight: FontWeight.w500)),
                                        Image.network(
                                          'https://api.surfit.io/v1/category/content-cover/develop/git/2x',
                                          width: 38,
                                          height: 38,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text("#Android",
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Pretendard",
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text("#Ai",
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Pretendard",
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // 각지게 만들기 위한 값
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF4B66DC)),
                                        fixedSize: MaterialStateProperty
                                            .all<Size>(Size.fromHeight(
                                                50)), // 높이는 고정, 가로는 디바이스에 맞추어 유동적으로
                                      ),
                                      child: const Text("내 QnA 보기",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Pretendard",
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFFFFFFFF))),
                                    ))
                              ],
                            ),
                          ))
                    ]);
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    // Flexible(
                    //   fit: FlexFit.tight,
                    //   child:
                      Container(
                      width: double.infinity,
                      color: Color(0xFFF5FBFF),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(26, 26, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${testContentsName[idx - 1]}",
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                )),
                            Container(
                              padding: EdgeInsets.only(right: 28),
                              child: Text(
                                "${testContentsInfo[idx - 1]}",
                                style: const TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  color: Color(0xFF818181)
                                ),
                                overflow: TextOverflow.ellipsis,
                              softWrap: true,
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(
                              height: 26,
                            )
                          ],
                        ),
                      ),


                    ),
              // )
                  ],
                );
              }
            }));
  }
}
