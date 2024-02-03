import 'dart:convert';
import 'dart:io';
import 'package:bigsogo/main_service/bottom_service/setting/myQnA.dart';
import 'package:bigsogo/main_service/bottom_service/setting/refact_major.dart';
import 'package:bigsogo/main_service/data/UserDataModel.dart';
import 'package:bigsogo/main_service/data/UserProfile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';

import '../../../log_in/login_activity.dart';
import '../../data/BaseData.dart';
import 'CreatePotofolio.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  final inputNameController = TextEditingController();
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  Logger logger = Logger();
  late UserProfile myInfo;
  late BaseProfileData myProfile;
  String userProfileImg = "";
  static final storage =
      FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userToken = ''; // storage에 있는 유저 정보를 저장
  List<ProfileProfilesData> userContents = [];
  List<String> userMajar = ["없"];
  String userName = "";
  int userId = 0;
  String info = "안녕하세요 안드로이드 개발을 잘 하는 부산 이성은입니다.";

  Future<UserProfile?> getMyProfile(int userId) async {
    final response = await http.get(Uri.parse("http://152.67.214.13:8080/profile/${userId}"), headers: {'Content-Type': 'application/json'});
    logger.d("aaaa${response}");
    var result = BaseProfileData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    logger.d("${response.statusCode}");
    if (response.statusCode == 200) {
      logger.d(result.data);
      if (result.data != null){
        userContents = result.data.profiles;
        return result.data;
      }
    } else {
      logger.d(result);
      throw Exception('Failed to load album');

    }

  }
  Future<UserProfile> fetchAndUseUserProfile(int userId) async {
    UserProfile? userProfile = await getMyProfile(userId);
    if (userProfile != null) {
      setState(() {
        userContents = userProfile.profiles;
        userMajar = userProfile.user.major;
        userName = userProfile.user.username;
        userProfileImg = userProfile.user.profile_img;
        logger.d("$userName, $userMajar, $userContents");
      });
    }
    
    // 이제 userProfile을 사용할 수 있습니다

    return userProfile!;
  }
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userToken = await storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userToken != null) {
      logger.d("$userToken");
      final response = await http.get(
          Uri.parse("http://152.67.214.13:8080/user"),
          headers: {HttpHeaders.authorizationHeader: userToken});

      var result = BaseUserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      logger.d("statusCode : ${result.data.id}");
      if (result.code == 200) {
        userId = result.data.id;
        return fetchAndUseUserProfile(result.data.id);
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.separated(
            shrinkWrap: true,
            itemCount: (userContents != null ? userContents.length:0)  + 1,
            itemBuilder: (BuildContext ctx, int idx) {
              if (idx == 0) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          color: Color(0xFFFFFFFF),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Theme(
                                            data:
                                            Theme.of(context).copyWith(
                                              splashColor: Colors.grey,
                                            ),
                                            child:
                                            PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(width: 1, color: Colors.white),
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              shadowColor: Colors.black,
                                              itemBuilder: (context) {
                                                return [
                                                  _menuItem("이름 변경"),
                                                  _menuItem("전공 변경"),
                                                ];
                                              },
                                            ))
                                      ],
                                    ),
                                    SizedBox(height: 28,),
                                    InkWell(
                                      child: Image.network(
                                        '${userProfileImg}',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      onTap: () async {
                                        FilePickerResult? imgFile = await FilePicker.platform.pickFiles();
                                        if (imgFile != null){
                                          var uri = Uri.parse("http://152.67.214.13:8080/user/update-image");
                                          var request = http.MultipartRequest('PATCH', uri);
                                          final filePath = imgFile.files.single.path;
                                          logger.d("path : $filePath");
                                          request.files.add(await http.MultipartFile.fromPath('file', filePath!));
                                          request.headers.addAll({
                                            'Content-Type': 'multipart/form-data',
                                            'Authorization': '$userToken',
                                          });
                                          try{
                                            var response = await request.send();
                                            if (response.statusCode == 200) {
                                              var responseBody = await response.stream.bytesToString();
                                              var jsonData = json.decode(responseBody);
                                              var baseData = BaseData.fromJson(jsonData);
                                              setState(() {
                                                userProfileImg = baseData.data;
                                              });
                                              logger.d(await response.stream.bytesToString());
                                            } else {
                                              logger.d('업로드 실패: ${response.reasonPhrase}');
                                            }
                                          }
                                          catch(e){
                                            logger.d("$e");
                                          }
                                        }
                                      },
                                    ),
                                    Text(
                                      "${userName}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: "Pretendard",
                                            fontWeight: FontWeight.bold,
                                            )
                                    ),
                                    SizedBox(height: 50,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => MyQnA(userId: userId)),
                                                );
                                              },
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          10.0), // 각지게 만들기 위한 값
                                                    )),
                                                backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Color(0xFF4B66DC)),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size.fromHeight(
                                                    40)), // 높이는 고정, 가로는 디바이스에 맞추어 유동적으로
                                              ),
                                              child: const Text("내 QnA 보기",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Pretendard",
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFFFFFFFF))),
                                            ),),
                                        SizedBox(width: 10,),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  CreatePotofolio()),
                                              );
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        10.0), // 각지게 만들기 위한 값
                                                  )),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFF4B66DC)),
                                              fixedSize: MaterialStateProperty
                                                  .all<Size>(Size.fromHeight(
                                                  40)), // 높이는 고정, 가로는 디바이스에 맞추어 유동적으로
                                            ),
                                            child: const Text("포토폴리오 추가",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Pretendard",
                                                    fontWeight: FontWeight.normal,
                                                    color: Color(0xFFFFFFFF))),
                                          ),),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 80,
                                      child: Row(
                                        children: [
                                          ListView.builder(
                                            itemCount: userMajar.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                TextButton(
                                                          onPressed: () {},
                                                          child: Text("#${userMajar[index]}",
                                                              textAlign: TextAlign.start,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: "Pretendard",
                                                                  fontWeight: FontWeight.w500)),
                                                        ),
                                                        SizedBox(
                                                            width: 3)
                                                ],
                                              );
                                            },
                                          )
                                        ],
                                      ),

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ]);
              } else {
                logger.d("testmessage");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        logger.d("${userContents[idx - 1].id}");
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xFFFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${userContents[idx - 1].subject}",
                                  style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  )),
                              Text(
                                "${userContents[idx - 1].id}",
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
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }, separatorBuilder: (BuildContext context, int index) {
              return Divider();
              },));
  }
  PopupMenuItem<String> _menuItem(String text) {
    return PopupMenuItem<String>(
      enabled: true,

      /// 해당 항목 선택 시 호출
      onTap: () {
        if (text == "이름 변경"){
          logger.d("이름변경");
          FlutterDialog();
        }
        else if(text == "전공 변경"){
          logger.d("전공변경");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Refact_major(nowMajor : userMajar)),
          );
        }
      },

      /// value = value에 입력한 값이 PopupMenuButton의 initialValue와 같다면
      /// 해당 아이템 선택된 UI 효과 나타남
      /// 만약 원하지 않는다면 Theme 에서 highlightColor: Colors.transparent 설정
      value: text,
      height: 70,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text("바꿀 이름을 입력해 주세요.")
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: inputNameController,
                )
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("확인"),
                onPressed: () {
                  if (inputNameController.text != null){

                  }
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
// 아오 짜증나네